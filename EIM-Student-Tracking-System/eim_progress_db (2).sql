-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 22, 2026 at 07:26 AM
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
(1, '2025-2026', NULL, '2026-02-22 03:58:40', NULL);

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
(1, 'EIM-001', 'Install electrical lighting systems, auxiliary outlets, and lighting fixtures', 'Install and configure electrical lighting systems including auxiliary outlets and various lighting fixtures according to electrical standards and safety regulations.', '2026-02-22 04:06:28', NULL),
(3, 'EIM-002', 'Install electrical protective devices for lighting and grounding systems', 'Install protective devices such as circuit breakers, fuses, and grounding systems to ensure electrical safety and compliance with standards.', '2026-02-22 04:06:57', NULL),
(4, 'EIM-003', 'Install wiring devices for floor and wall-mounted outlets, lighting fixtures, and switches', 'Install and wire various electrical devices including floor and wall-mounted outlets, lighting fixtures, and switches following proper wiring techniques.', '2026-02-22 04:06:57', NULL),
(5, 'EIM-004', 'Apply quality standards', 'Apply and maintain quality standards in all electrical installation work to ensure reliability, safety, and compliance with industry regulations.', '2026-02-22 04:06:57', NULL),
(6, 'EIM-005', 'Perform computer operations', 'Perform basic computer operations including documentation, reporting, and using software tools relevant to electrical installation and maintenance work.', '2026-02-22 04:06:57', NULL),
(7, 'EIM-006', 'Perform mensuration and calculation', 'Perform accurate measurements and calculations required for electrical installations including load calculations, material estimates, and circuit designs.', '2026-02-22 04:06:57', NULL);

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
(1, 2, 'Bryan Sacurom', 'sacurom@gmail.com', 1, '2026-02-05', 'active', 'EIM NC II', '2026-02-22 03:59:09', '2026-02-22 04:09:15');

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
(1, 4, 'in_progress', 87, '2026-02-22', 'Goods', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin@example.com', '$2y$10$N4HdmTPNr8s28a.SgDgHAer2F/VerwsXlCUVl1KEstIXHYJcGSN6e', 'admin', '2026-02-22 03:56:42', NULL),
(2, 'Bryan', 'sacurom@gmail.com', '$2y$10$gLgosDkhWpaCLndwLEPVvuRomIZFAw6GwUlxjuONkxr.jgurQJ8Ta', 'student', '2026-02-22 03:59:09', NULL);

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
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `batches`
--
ALTER TABLE `batches`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `competencies`
--
ALTER TABLE `competencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
