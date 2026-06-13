#!/bin/bash
# a1-exam.sh - A1试卷开发唯一入口
# 用法: ./a1-exam.sh

set -e
cd /Users/wusheng820/Downloads/goethe-a1-exam

echo "🚀 A1试卷开发系统"
echo ""
echo "使用Master Skill（带完整前中后Review机制）"
echo ""

./.claude/skills/master-skill.sh

exit 0
