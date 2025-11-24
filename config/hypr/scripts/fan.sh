#!/bin/bash

# Файл для отслеживания текущего состояния
STATE_FILE="/tmp/fan_control_state"

# Проверяем текущее состояние
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "manual" ]; then
    # Переключаем в автоматический режим
    echo "Переключаем вентилятор в АВТОМАТИЧЕСКИЙ режим"
    echo "level auto" | sudo tee /proc/acpi/ibm/fan
    
    # Сохраняем состояние
    echo "auto" > "$STATE_FILE"
else
    # Переключаем в ручной режим на максимальную скорость
    echo "Переключаем вентилятор в РУЧНОЙ режим (макс. скорость)"
    echo 255 | sudo tee /sys/class/hwmon/hwmon*/pwm1
    
    # Сохраняем состояние
    echo "manual" > "$STATE_FILE"
fi

# Показываем текущее состояние
echo "Текущий режим: $(cat "$STATE_FILE")"
