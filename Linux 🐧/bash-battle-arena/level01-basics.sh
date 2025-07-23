#!/bin/bash

# CoderCO Bash Battle Arena - Level 1: Basics
# Challenge: Create directory and files in Arena/

echo "🎮 Bash Battle Arena - Level 1: Basics"
echo "========================================="
echo

echo "📁 Creating Arena directory..."
mkdir -p Arena

echo "📄 Creating hero.txt file..."
echo "Welcome to the Arena, brave hero!" > Arena/hero.txt

echo "⚔️ Creating weapon.txt file..."
echo "You have acquired: Legendary Bash Sword" > Arena/weapon.txt

echo "🏆 Creating quest.txt file..."
echo "Quest: Master the basics of file creation and directory navigation" > Arena/quest.txt

echo
echo "✅ Level 1 Complete!"
echo "Files created in Arena/:"
ls -la Arena/

echo
echo "🎯 Next Challenge: Level 2 - File Inspection"
