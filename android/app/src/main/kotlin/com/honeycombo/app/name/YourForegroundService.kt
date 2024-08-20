package com.honeycombo.app.name

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build

class YourForegroundService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "MediaProjection"
            val channel = NotificationChannel(
                channelId,
                "MediaProjection Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
            val notification = Notification.Builder(this, channelId)
                .setContentTitle("Recording in Progress")
                .setContentText("Recording screen")
                .setSmallIcon(R.drawable.ic_notification)  // 적절한 아이콘 설정
                .build()
            startForeground(1, notification)
        }

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}