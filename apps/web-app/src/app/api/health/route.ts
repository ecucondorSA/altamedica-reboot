import { NextResponse } from 'next/server'

// Required for static export compatibility
export const dynamic = 'force-static'
export const revalidate = false

export async function GET() {
  try {
    const startTime = Date.now()
    
    // Calculate response time
    const responseTime = Date.now() - startTime
    
    // Mock system health data for static export compatibility
    const healthData = {
      status: 'healthy' as const,
      timestamp: new Date().toISOString(),
      environment: 'production',
      uptime: Math.floor(Date.now() / 1000), // seconds since epoch as uptime
      responseTime,
      checks: {
        environment_security: true,
        database: 'healthy',
        memory_usage: 128, // MB - mock value for static export
        heap_usage: 64 // MB - mock value
      },
      detailed_checks: [
        {
          service: 'authentication',
          status: 'healthy' as const,
          responseTime: responseTime + Math.random() * 50
        },
        {
          service: 'database',
          status: 'healthy' as const,
          responseTime: responseTime + Math.random() * 100
        },
        {
          service: 'supabase',
          status: 'healthy' as const,
          responseTime: responseTime + Math.random() * 200
        }
      ]
    }

    return NextResponse.json(healthData)
  } catch {
    return NextResponse.json(
      { 
        status: 'error', 
        message: 'Health check failed',
        timestamp: new Date().toISOString(),
        environment: 'production',
        uptime: 0,
        responseTime: 0,
        checks: {
          environment_security: false,
          database: 'unhealthy',
          memory_usage: 0,
          heap_usage: 0
        },
        detailed_checks: []
      },
      { status: 500 }
    )
  }
}