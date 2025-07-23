#!/bin/bash

# File to store to-do items
TODO_FILE="todos.txt"
touch "$TODO_FILE"

while true; do
    echo ""
    echo "===== To-Do List Manager ====="
    echo "Choose an action:"
    echo "  ls   - List tasks"
    echo "  add  - Add a new task"
    echo "  rm   - Remove a task"
    echo "  exit - Quit"
    echo "================================"
    read -rp "Enter your choice: " Choice

    # Check if input is empty
    if [ -z "$Choice" ]; then
        echo "❌ Invalid input. Please enter a command."
        continue
    fi

    case $Choice in
        ls)
            if [ -s "$TODO_FILE" ]; then
                echo "📋 Your To-Do List:"
                nl -w2 -s'. ' "$TODO_FILE"
            else
                echo "✅ No To-Dos found. You're all caught up!"
            fi
            ;;
        
        add)
            echo "✍️ Enter your new To-Do:"
            read -r new_todo
            if [ -z "$new_todo" ]; then
                echo "❌ Task cannot be empty."
            else
                echo "$new_todo" >> "$TODO_FILE"
                echo "✅ New To-Do added."
            fi
            ;;
        
        rm)
            if [ -s "$TODO_FILE" ]; then
                echo "🗑 Your To-Dos:"
                nl -w2 -s'. ' "$TODO_FILE"
                echo "Enter the number of the To-Do to remove:"
                read -r todo_number
                if [[ "$todo_number" =~ ^[0-9]+$ ]] && [ "$todo_number" -gt 0 ]; then
                    sed -i "${todo_number}d" "$TODO_FILE"
                    echo "✅ To-Do removed."
                else
                    echo "❌ Invalid number. Please try again."
                fi
            else
                echo "✅ No To-Dos to remove."
            fi
            ;;
        
        exit)
            echo "👋 Exiting To-Do List. Bye!"
            break
            ;;

        *)
            echo "❌ Invalid choice. Please enter ls, add, rm, or exit."
            ;;
    esac
done
