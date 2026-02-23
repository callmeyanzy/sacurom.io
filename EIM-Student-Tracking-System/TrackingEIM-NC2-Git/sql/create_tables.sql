-- EIM Student Tracking System - Database Table Creation Script
-- Run these SQL commands one by one in phpMyAdmin

-- ============================================
-- Table 1: users
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'student',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table 2: batches
-- ============================================
CREATE TABLE IF NOT EXISTS batches (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  year INT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table 3: competencies
-- ============================================
CREATE TABLE IF NOT EXISTS competencies (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  code VARCHAR(50) NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uniq_competencies_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table 4: students
-- ============================================
CREATE TABLE IF NOT EXISTS students (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id INT UNSIGNED NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NULL,
  batch_id INT UNSIGNED NULL,
  enrollment_date DATE NULL,
  status ENUM('active','inactive','graduated') NOT NULL DEFAULT 'active',
  tesda_qualification VARCHAR(100) DEFAULT 'EIM NC II',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_students_batch_id (batch_id),
  INDEX idx_students_user_id (user_id),
  CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table 5: student_competencies
-- ============================================
CREATE TABLE IF NOT EXISTS student_competencies (
  student_id INT UNSIGNED NOT NULL,
  competency_id INT UNSIGNED NOT NULL,
  status ENUM('not_started','in_progress','completed') NOT NULL DEFAULT 'not_started',
  practical_score INT NULL,
  assessment_date DATE NULL,
  remarks TEXT NULL,
  updated_at TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, competency_id),
  CONSTRAINT fk_sc_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_sc_competency FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table 6: assessments
-- ============================================
CREATE TABLE IF NOT EXISTS assessments (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id INT UNSIGNED NOT NULL,
  competency_id INT UNSIGNED NOT NULL,
  assessment_type VARCHAR(50) NOT NULL,
  score INT NULL,
  result ENUM('pass','fail','pending') NOT NULL DEFAULT 'pending',
  assessed_by INT UNSIGNED NULL,
  assessed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  remarks TEXT NULL,
  PRIMARY KEY (id),
  INDEX idx_assessments_student (student_id),
  INDEX idx_assessments_competency (competency_id),
  CONSTRAINT fk_assessments_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  CONSTRAINT fk_assessments_competency FOREIGN KEY (competency_id) REFERENCES competencies(id) ON DELETE CASCADE,
  CONSTRAINT fk_assessments_assessor FOREIGN KEY (assessed_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insert Default Admin User
-- Password: admin123
-- ============================================
INSERT INTO users (name, email, password, role) VALUES 
('Administrator', 'admin@eim.local', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin');

-- ============================================
-- Insert Sample Competencies
-- ============================================
INSERT INTO competencies (code, title, description) VALUES
('EIM-NC2-001', 'Install and Configure Electrical Systems', 'Basic installation and configuration of electrical systems'),
('EIM-NC2-002', 'Maintain and Repair Electrical Systems', 'Maintenance and repair procedures'),
('EIM-NC2-003', 'Troubleshoot Electrical Systems', 'Diagnostic and troubleshooting skills'),
('EIM-NC2-004', 'Apply Safety Practices', 'Workplace safety and best practices');
