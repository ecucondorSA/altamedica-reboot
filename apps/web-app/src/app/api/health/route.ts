import { NextResponse } from 'next/server'

// Required for static export compatibility
export const dynamic = 'force-static'
export const revalidate = false

export async function GET() {
  try {
    return NextResponse.json({
      status: 'ok',
      timestamp: new Date().toISOString(),
      service: 'autamedica-web-app',
      version: '1.0.0'
    })
  } catch {
    return NextResponse.json(
      { 
        status: 'error', 
        message: 'Health check failed',
        timestamp: new Date().toISOString()
      },
      { status: 500 }
    )
  }
}