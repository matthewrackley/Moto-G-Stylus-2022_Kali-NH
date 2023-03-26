#!/sbin/sh

# Granting required permissions to NetHunter app
pm grant -g com.offsec.nethunter android.permission.INTERNET
pm grant -g com.offsec.nethunter android.permission.ACCESS_WIFI_STATE
pm grant -g com.offsec.nethunter android.permission.CHANGE_WIFI_STATE
pm grant -g com.offsec.nethunter android.permission.READ_EXTERNAL_STORAGE
pm grant -g com.offsec.nethunter android.permission.WRITE_EXTERNAL_STORAGE
pm grant -g com.offsec.nethunter com.offsec.nhterm.permission.RUN_SCRIPT
pm grant -g com.offsec.nethunter com.offsec.nhterm.permission.RUN_SCRIPT_SU
pm grant -g com.offsec.nethunter com.offsec.nhterm.permission.RUN_SCRIPT_NH
pm grant -g com.offsec.nethunter com.offsec.nhterm.permission.RUN_SCRIPT_NH_LOGIN
pm grant -g com.offsec.nethunter android.permission.RECEIVE_BOOT_COMPLETED
pm grant -g com.offsec.nethunter android.permission.WAKE_LOCK
pm grant -g com.offsec.nethunter android.permission.VIBRATE
pm grant -g com.offsec.nethunter android.permission.FOREGROUND_SERVICE
