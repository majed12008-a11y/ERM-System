-- Active: 1780349863919@@127.0.0.1@5432@ethics_db@security
-- Migration: Add question_options column to review_questions
-- This column stores comma-separated options for CHOICE type questions

ALTER TABLE committee.review_questions
ADD COLUMN IF NOT EXISTS question_options TEXT;
