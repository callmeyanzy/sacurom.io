-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 23, 2026 at 04:00 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `eim_progress_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `assessments`
--

CREATE TABLE `assessments` (
  `id` int(10) UNSIGNED NOT NULL,
  `student_id` int(10) UNSIGNED NOT NULL,
  `competency_id` int(10) UNSIGNED NOT NULL,
  `assessment_type` varchar(50) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `result` enum('pass','fail','pending') NOT NULL DEFAULT 'pending',
  `assessed_by` int(10) UNSIGNED DEFAULT NULL,
  `assessed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `remarks` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `assessments`
--

INSERT INTO `assessments` (`id`, `student_id`, `competency_id`, `assessment_type`, `score`, `result`, `assessed_by`, `assessed_at`, `remarks`) VALUES
(1, 1, 2, 'Oral', 97, 'pass', 1, '2026-02-23 11:45:45', 'Goods'),
(2, 1, 3, 'Project', 99, 'pass', 1, '2026-02-23 11:50:03', ''),
(3, 1, 4, 'Oral', 87, 'pass', 1, '2026-02-23 11:54:44', 'Goods'),
(4, 2, 3, 'Oral', 87, 'pass', 1, '2026-02-23 12:10:31', 'goods'),
(5, 2, 1, 'Written', 95, 'pass', 1, '2026-02-23 12:11:36', 'Goods'),
(6, 3, 1, 'Oral', 85, 'pass', 1, '2026-02-23 12:20:06', 'GOODS');

-- --------------------------------------------------------

--
-- Table structure for table `batches`
--

CREATE TABLE `batches` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `year` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `batches`
--

INSERT INTO `batches` (`id`, `name`, `year`, `created_at`, `updated_at`) VALUES
(5, 'EIM-2025-2026', NULL, '2026-02-23 12:06:32', '2026-02-23 12:19:14'),
(6, 'EIM-2026-2027', NULL, '2026-02-23 14:53:55', NULL),
(7, 'EIM-2026-2027', NULL, '2026-02-23 14:54:47', NULL),
(8, 'EIM-2026-2027', NULL, '2026-02-23 14:54:56', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `competencies`
--

CREATE TABLE `competencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `competencies`
--

INSERT INTO `competencies` (`id`, `code`, `title`, `description`, `created_at`, `updated_at`) VALUES
(1, 'EIM-NC2-001', 'Install and Configure Electrical Systems', 'Basic installation and configuration of electrical systems', '2026-02-23 11:26:55', NULL),
(2, 'EIM-NC2-002', 'Maintain and Repair Electrical Systems', 'Maintenance and repair procedures', '2026-02-23 11:26:55', NULL),
(3, 'EIM-NC2-003', 'Troubleshoot Electrical Systems', 'Diagnostic and troubleshooting skills', '2026-02-23 11:26:55', NULL),
(4, 'EIM-NC2-004', 'Apply Safety Practices', 'Workplace safety and best practices', '2026-02-23 11:26:55', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `batch_id` int(10) UNSIGNED DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `status` enum('active','inactive','graduated') NOT NULL DEFAULT 'active',
  `tesda_qualification` varchar(100) DEFAULT 'EIM NC II',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `user_id`, `name`, `email`, `batch_id`, `enrollment_date`, `status`, `tesda_qualification`, `created_at`, `updated_at`) VALUES
(1, 3, 'SacuromBryan', 'Sacurom@gmail.com', 5, '2026-02-13', 'active', 'EIM NC II', '2026-02-23 11:40:56', '2026-02-23 12:24:33'),
(2, 4, 'bryansacurom', 'admin@gmail.com', 5, '2026-02-19', 'active', 'EIM NC II', '2026-02-23 12:10:07', '2026-02-23 12:10:07'),
(3, 10, 'bisayaVStagalog', 'sacurom073@gmail.com', 5, '2026-02-23', 'active', 'EIM NC II', '2026-02-23 12:17:46', '2026-02-23 12:24:27');

-- --------------------------------------------------------

--
-- Table structure for table `student_competencies`
--

CREATE TABLE `student_competencies` (
  `student_id` int(10) UNSIGNED NOT NULL,
  `competency_id` int(10) UNSIGNED NOT NULL,
  `status` enum('not_started','in_progress','completed') NOT NULL DEFAULT 'not_started',
  `practical_score` int(11) DEFAULT NULL,
  `assessment_date` date DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `student_competencies`
--

INSERT INTO `student_competencies` (`student_id`, `competency_id`, `status`, `practical_score`, `assessment_date`, `remarks`, `updated_at`) VALUES
(1, 1, 'not_started', NULL, NULL, NULL, NULL),
(1, 2, 'completed', 97, '2026-02-23', 'Goods', '2026-02-23 11:45:45'),
(1, 3, 'completed', 99, '2026-02-23', '', '2026-02-23 11:50:03'),
(1, 4, 'in_progress', 87, '2026-02-23', 'Goods', '2026-02-23 11:54:44'),
(2, 1, 'completed', 95, '2026-02-23', 'Goods', '2026-02-23 12:11:36'),
(2, 2, 'not_started', NULL, NULL, NULL, NULL),
(2, 3, 'in_progress', 87, '2026-02-23', 'goods', '2026-02-23 12:10:31'),
(2, 4, 'not_started', NULL, NULL, NULL, NULL),
(3, 1, 'completed', 85, '2026-02-23', 'GOODS', '2026-02-23 12:20:06'),
(3, 2, 'not_started', NULL, NULL, NULL, NULL),
(3, 3, 'not_started', NULL, NULL, NULL, NULL),
(3, 4, 'not_started', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'student',
  `oauth_provider` varchar(20) DEFAULT NULL,
  `oauth_id` varchar(255) DEFAULT NULL,
  `avatar_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `oauth_provider`, `oauth_id`, `avatar_url`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin@eim.local', '$2y$10$pgAdtgPuAokp8pbkrrh/C.0KYwKu9klR1dJWnoZU2QuXi0K6Rf7wO', 'admin', NULL, NULL, NULL, '2026-02-23 11:26:55', '2026-02-23 11:32:25'),
(2, 'bryansacurom', 'y4nn4n@gmail.com', '$2y$10$uY0woIy9cs4h3NefzEP9GudksYCc1qofPin1ruJnQjmy4HKng1cbi', 'student', NULL, NULL, NULL, '2026-02-23 11:39:18', NULL),
(3, 'SacuromBryan', 'Sacurom@gmail.com', '$2y$10$G0TB1OuEUgnHR.27WZlXcOqwuIXmdAwtmCAaDgcUnYEm54t2vobHa', 'student', NULL, NULL, NULL, '2026-02-23 11:40:56', NULL),
(4, 'bryansacurom', 'admin@gmail.com', '$2y$10$/daB8cLXqBnK09bGBwGl/u0FtG1hmtOAcHb0A8P6szDf.7jABjVzS', 'student', NULL, NULL, NULL, '2026-02-23 12:10:07', NULL),
(9, 'bisayaVStagalog', 'sacurom07@gmail.com', '$2y$10$NzNOYcL/cW4NK70WMmEhIunvxYZ727xIxij1kqwiqzRw1Ffw.utOC', 'admin', NULL, NULL, NULL, '2026-02-23 12:16:50', NULL),
(10, 'bisayaVStagalog', 'sacurom073@gmail.com', '$2y$10$Xcmokio9ldb28RVF5Mi0IeSJ4fvx85JQMmBTQYgY1gPXkhRPSm9ca', 'student', NULL, NULL, NULL, '2026-02-23 12:17:46', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assessments`
--
ALTER TABLE `assessments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_assessments_student` (`student_id`),
  ADD KEY `idx_assessments_competency` (`competency_id`),
  ADD KEY `fk_assessments_assessor` (`assessed_by`);

--
-- Indexes for table `batches`
--
ALTER TABLE `batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `competencies`
--
ALTER TABLE `competencies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_competencies_code` (`code`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_students_batch_id` (`batch_id`),
  ADD KEY `idx_students_user_id` (`user_id`);

--
-- Indexes for table `student_competencies`
--
ALTER TABLE `student_competencies`
  ADD PRIMARY KEY (`student_id`,`competency_id`),
  ADD KEY `fk_sc_competency` (`competency_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assessments`
--
ALTER TABLE `assessments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `batches`
--
ALTER TABLE `batches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `competencies`
--
ALTER TABLE `competencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `assessments`
--
ALTER TABLE `assessments`
  ADD CONSTRAINT `fk_assessments_assessor` FOREIGN KEY (`assessed_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_assessments_competency` FOREIGN KEY (`competency_id`) REFERENCES `competencies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_assessments_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `student_competencies`
--
ALTER TABLE `student_competencies`
  ADD CONSTRAINT `fk_sc_competency` FOREIGN KEY (`competency_id`) REFERENCES `competencies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sc_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
