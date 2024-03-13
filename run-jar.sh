#!/bin/bash

java_file="a.java"
log_dir="logs"

# 프로세스 종료 함수
function kill_process() {
    pid=$(pgrep -f "java -jar $java_file")
    if [[ -n $pid ]]; then
        kill -9 $pid
    fi
}

current_date=$(date +"%y%m%d")
log_file="$log_dir/log_$current_date.txt"

# 로그 파일 생성
mkdir -p "$log_dir"
touch "$log_file"

# 프로세스 종료 여부 확인
if pgrep -f "java -jar $java_file" >/dev/null; then
    # 이미 실행 중인 프로세스가 있을 경우 종료
    kill_process
else
    # 실행 중인 프로세스가 없을 경우 로그 파일에 날짜 기록
    echo "Process started: $current_date" >> "$log_file"
fi

# 프로세스 실행
java -jar "$java_file" >> "$log_file" 2>&1 &

# 프로세스 실행 여부 확인
while pgrep -f "java -jar $java_file" >/dev/null; do
    # 일자 갱신
    current_date=$(date +"%y%m%d")
    log_file="$log_dir/log_$current_date.txt"
    sleep 1h
done

# 프로세스 종료 후 로그 파일에 날짜 기록
echo "Process ended: $current_date" >> "$log_file"
