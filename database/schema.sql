-- AutaMedica Database Schema
-- Generated: 2025-09-19
-- Supabase Project: gtyvdircfhmdjiaelqkg

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE,
    email VARCHAR NOT NULL,
    role VARCHAR CHECK (role IN ('patient', 'doctor', 'company_admin', 'admin', 'platform_admin')) DEFAULT 'patient',
    first_name VARCHAR,
    last_name VARCHAR,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (id)
);

-- RLS Policies for Profiles
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile" ON public.profiles
FOR SELECT USING (auth.uid() = id);

-- Policy: Users can update their own profile (cannot self-promote roles)
CREATE POLICY "Users can update own profile" ON public.profiles
FOR UPDATE USING (auth.uid() = id)
WITH CHECK (auth.uid() = id AND role = COALESCE(OLD.role, 'patient'));

-- Policy: Users can insert their own profile
CREATE POLICY "Users can insert own profile" ON public.profiles
FOR INSERT WITH CHECK (auth.uid() = id);

-- Policy: Admins can view all profiles
CREATE POLICY "Admins can view all profiles" ON public.profiles
FOR SELECT USING (
    EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() 
        AND role IN ('admin', 'platform_admin')
    )
);

-- Policy: Admins can update any profile (including role changes)
CREATE POLICY "Admins can update any profile" ON public.profiles
FOR UPDATE USING (
    EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() 
        AND role IN ('admin', 'platform_admin')
    )
);

-- Policy: Admins can delete profiles
CREATE POLICY "Admins can delete profiles" ON public.profiles
FOR DELETE USING (
    EXISTS (
        SELECT 1 FROM public.profiles 
        WHERE id = auth.uid() 
        AND role IN ('admin', 'platform_admin')
    )
);

-- Function to handle new user registration (secure role validation)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
    user_role VARCHAR;
BEGIN
    -- Extract role from metadata with security validation
    user_role := NEW.raw_user_meta_data->>'role';
    
    -- Only allow safe roles for self-registration
    -- Admins must be created through controlled processes
    IF user_role NOT IN ('patient', 'doctor', 'company_admin') THEN
        user_role := 'patient';
    END IF;
    
    INSERT INTO public.profiles (id, email, role)
    VALUES (
        NEW.id,
        NEW.email,
        user_role
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger for new user registration
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update updated_at
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Grant minimal necessary permissions (principle of least privilege)
GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT ON public.profiles TO anon;

-- Enable realtime for profiles table
ALTER publication supabase_realtime ADD TABLE public.profiles;

-- Comments for documentation
COMMENT ON TABLE public.profiles IS 'User profiles with role-based access control';
COMMENT ON COLUMN public.profiles.role IS 'User role: patient, doctor, company_admin, admin, platform_admin (company removed for consistency)';
COMMENT ON POLICY "Users can view own profile" ON public.profiles IS 'Users can only view their own profile information';
COMMENT ON POLICY "Admins can view all profiles" ON public.profiles IS 'Platform and regular admins can view all user profiles';