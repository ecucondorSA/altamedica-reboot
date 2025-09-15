'use client'

import React, { createContext, useContext, useEffect, useState, useCallback } from 'react'
import { User, Session } from '@supabase/supabase-js'
import { createClient, UserProfile, UserRole, getRoleRedirectUrl } from './supabase'

interface AuthContextType {
  user: User | null
  userProfile: UserProfile | null
  session: Session | null
  loading: boolean
  signOut: () => Promise<void>
  redirectToRole: () => void
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

export function useAuth() {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider')
  }
  return context
}

interface AuthProviderProps {
  children: React.ReactNode
}

export function AuthProvider({ children }: AuthProviderProps) {
  const [user, setUser] = useState<User | null>(null)
  const [userProfile, setUserProfile] = useState<UserProfile | null>(null)
  const [session, setSession] = useState<Session | null>(null)
  const [loading, setLoading] = useState(true)
  const [clientReady, setClientReady] = useState(false)
  const supabase = createClient()

  const fetchUserProfile = useCallback(async (userId: string) => {
    if (!supabase) return

    try {
      const { data, error } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('id', userId)
        .single()

      if (error) {
        // If table doesn't exist or user profile not found, create a mock profile
        if (error.code === 'PGRST116' || error.code === '42P01') {
          console.log('User profiles table not found, using mock profile')
          const mockProfile: UserProfile = {
            id: userId,
            email: user?.email ?? '',
            role: 'patient',
            created_at: new Date().toISOString(),
            updated_at: new Date().toISOString()
          }
          setUserProfile(mockProfile)
          return
        }
        console.log('User profile not found, using default profile')
        return
      }

      setUserProfile(data as UserProfile)
    } catch {
      console.log('Error accessing user profiles, using default profile')
      // Create a default profile for development
      if (user) {
        const defaultProfile: UserProfile = {
          id: userId,
          email: user.email ?? '',
          role: 'patient',
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString()
        }
        setUserProfile(defaultProfile)
      }
    }
  }, [supabase, user])

  // Initialize client readiness on mount
  useEffect(() => {
    setClientReady(!!supabase)
    if (!supabase) {
      setLoading(false)
    }
  }, [supabase])

  useEffect(() => {
    if (!clientReady || !supabase) return

    const getSession = async () => {
      const { data: { session } } = await supabase.auth.getSession()
      setSession(session)
      setUser(session?.user ?? null)

      if (session?.user) {
        await fetchUserProfile(session.user.id)
      }
      setLoading(false)
    }

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        setSession(session)
        setUser(session?.user ?? null)

        if (event === 'SIGNED_IN' && session?.user) {
          await fetchUserProfile(session.user.id)
        } else if (event === 'SIGNED_OUT') {
          setUserProfile(null)
        }
        setLoading(false)
      }
    )

    getSession()

    return () => subscription.unsubscribe()
  }, [clientReady, supabase, fetchUserProfile])

  const signOut = async () => {
    if (!supabase) return

    const { error } = await supabase.auth.signOut()
    if (error) {
      console.error('Error signing out:', error)
    }
  }

  const redirectToRole = () => {
    if (!userProfile?.role) {
      console.warn('No user role available for redirection')
      return
    }

    const redirectUrl = getRoleRedirectUrl(userProfile.role as UserRole)
    window.location.href = redirectUrl
  }

  const value: AuthContextType = {
    user,
    userProfile,
    session,
    loading,
    signOut,
    redirectToRole
  }

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  )
}