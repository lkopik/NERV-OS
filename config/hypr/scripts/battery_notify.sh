#!/bin/bash

# Конфигурация
NOTIFICATION_COOLDOWN=300  # 5 минут в секундах
LAST_NOTIFICATION_TIME=0

send_notification() {
    local message="$1"
    # Отправляем уведомление (без попытки удалить предыдущие)
    notify-send -u critical "Евангелион: Уровень LCL" "$message"
    # Дублируем в консоль для логов
    echo "NOTIFICATION: $message"
}

determine_batteries() {
    # Проверяем какие батареи доступны
    if [ -f /sys/class/power_supply/BAT0/capacity ]; then
        main_battery="BAT1"
    elif [ -f /sys/class/power_supply/BAT1/capacity ]; then
        main_battery="BAT0"
    else
        echo "Ошибка: батареи не найдены!"
        exit 1
    fi

    main_capacity=$(cat /sys/class/power_supply/$main_battery/capacity 2>/dev/null || echo 100)
    main_status=$(cat /sys/class/power_supply/$main_battery/status 2>/dev/null || echo "Unknown")
    
    echo "Основная батарея: $main_battery ($main_capacity%, статус: $main_status)"
}

check_battery() {
    local current_time=$(date +%s)
    local time_since_last=$((current_time - LAST_NOTIFICATION_TIME))
    
    determine_batteries
    
    # Пропускаем проверку если батарея заряжается
    if [[ "$main_status" == "Charging" ]]; then
        echo "Батарея заряжается. Уведомления отключены."
        return
    fi

    # Уведомления только для основной батареи
    if [ $time_since_last -ge $NOTIFICATION_COOLDOWN ]; then
        if [ "$main_capacity" -lt 30 ] && [ "$main_capacity" -ge 10 ]; then
            send_notification "LCL: $main_capacity%. Подключите внешний источник."
            LAST_NOTIFICATION_TIME=$current_time
        elif [ "$main_capacity" -lt 10 ]; then
            send_notification "LCL: $main_capacity%. Критический уровень!"
            LAST_NOTIFICATION_TIME=$current_time
        fi
    fi
}

# Основной цикл проверки
while true; do
    check_battery
    sleep 300  # Проверка каждые 5 минут
done
