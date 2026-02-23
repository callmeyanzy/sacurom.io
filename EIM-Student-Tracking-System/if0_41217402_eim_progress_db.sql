-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Host: sql306.byetcluster.com
-- Generation Time: Feb 22, 2026 at 01:31 AM
-- Server version: 11.4.10-MariaDB
-- PHP Version: 7.2.22

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `if0_41217402_eim_progress_db`
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
(1, 3, 3, 'Project', 75, 'pass', 1, '2026-02-20 04:59:18', 'Goods'),
(2, 2, 2, 'Practical', 89, 'pass', 1, '2026-02-20 05:07:03', 'Goods');

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
(2, '2024-B', 2024, '2026-02-20 04:39:30', NULL),
(3, '2025-A', 2025, '2026-02-20 04:39:30', NULL),
(5, '2024-B', 2024, '2026-02-20 04:39:48', NULL),
(6, '2025-A', 2025, '2026-02-20 04:39:48', NULL),
(7, '2024-A', 2024, '2026-02-20 04:40:06', NULL),
(8, '2024-B', 2024, '2026-02-20 04:40:06', NULL),
(9, '2025-A', 2025, '2026-02-20 04:40:06', NULL),
(10, '2024-A', 2024, '2026-02-20 04:40:25', NULL),
(11, '2024-B', 2024, '2026-02-20 04:40:25', NULL),
(12, '2025-A', 2025, '2026-02-20 04:40:25', NULL),
(13, '2024-A', 2024, '2026-02-20 04:41:04', NULL),
(14, '2024-B', 2024, '2026-02-20 04:41:04', NULL),
(15, '2025-A', 2025, '2026-02-20 04:41:04', NULL),
(16, '2024-A', 2024, '2026-02-20 04:41:29', NULL),
(17, '2024-B', 2024, '2026-02-20 04:41:29', NULL),
(18, '2025-A', 2025, '2026-02-20 04:41:29', NULL),
(19, 'Sacurom', NULL, '2026-02-20 04:58:09', NULL);

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
(1, 'EIM-001', 'Install Electrical Wiring', 'Install electrical wiring systems in residential and commercial buildings following safety standards and electrical codes.', '2026-02-20 04:39:30', NULL),
(2, 'EIM-002', 'Perform Roughing-in Activities', 'Perform roughing-in activities including conduit installation, box mounting, and wire pulling.', '2026-02-20 04:39:30', NULL),
(3, 'EIM-003', 'Install Lighting System', 'Install various lighting systems including switches, outlets, fixtures, and control systems.', '2026-02-20 04:39:30', NULL),
(4, 'EIM-004', 'Maintain Electrical System', 'Perform preventive maintenance and troubleshooting on electrical systems and equipment.', '2026-02-20 04:39:30', NULL),
(5, 'EIM-005', 'Troubleshoot Electrical Circuits', 'Diagnose and repair faults in electrical circuits using proper testing equipment.', '2026-02-20 04:39:30', NULL);

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
(1, 5, 'Pedro Reyes', 'pedro.reyes@example.com', 1, '2025-09-02', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:41:04'),
(2, 6, 'Ana Garcia', 'ana.garcia@example.com', 2, '2025-08-08', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:41:04'),
(3, 7, 'Carlos Mendoza', 'carlos.mendoza@example.com', 2, '2025-11-09', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:41:04'),
(4, 8, 'Sacurom', 'elena.torres@example.com', 2, '2025-12-31', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:57:53'),
(5, 9, 'Miguel Bautista', 'miguel.bautista@example.com', 3, '2025-05-09', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:41:04'),
(6, 10, 'Sofia Ramos', 'sofia.ramos@example.com', 3, '2025-10-11', 'active', 'EIM NC II', '2026-02-20 04:41:04', '2026-02-20 04:41:04');

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
(1, 2, 'not_started', NULL, NULL, NULL, NULL),
(1, 3, 'not_started', NULL, NULL, NULL, NULL),
(1, 4, 'not_started', NULL, NULL, NULL, NULL),
(1, 5, 'not_started', NULL, NULL, NULL, NULL),
(2, 1, 'not_started', NULL, NULL, NULL, NULL),
(2, 2, 'completed', 89, '2026-02-20', 'Goods', '2026-02-20 05:07:03'),
(2, 3, 'not_started', NULL, NULL, NULL, NULL),
(2, 4, 'not_started', NULL, NULL, NULL, NULL),
(2, 5, 'not_started', NULL, NULL, NULL, NULL),
(3, 1, 'not_started', NULL, NULL, NULL, NULL),
(3, 2, 'not_started', NULL, NULL, NULL, NULL),
(3, 3, 'completed', 75, '2026-02-20', 'Goods', '2026-02-20 04:59:18'),
(3, 4, 'not_started', NULL, NULL, NULL, NULL),
(3, 5, 'not_started', NULL, NULL, NULL, NULL),
(4, 1, 'not_started', NULL, NULL, NULL, NULL),
(4, 2, 'not_started', NULL, NULL, NULL, NULL),
(4, 3, 'not_started', NULL, NULL, NULL, NULL),
(4, 4, 'not_started', NULL, NULL, NULL, NULL),
(4, 5, 'not_started', NULL, NULL, NULL, NULL),
(5, 1, 'not_started', NULL, NULL, NULL, NULL),
(5, 2, 'not_started', NULL, NULL, NULL, NULL),
(5, 3, 'not_started', NULL, NULL, NULL, NULL),
(5, 4, 'not_started', NULL, NULL, NULL, NULL),
(5, 5, 'not_started', NULL, NULL, NULL, NULL),
(6, 1, 'not_started', NULL, NULL, NULL, NULL),
(6, 2, 'not_started', NULL, NULL, NULL, NULL),
(6, 3, 'not_started', NULL, NULL, NULL, NULL),
(6, 4, 'not_started', NULL, NULL, NULL, NULL),
(6, 5, 'not_started', NULL, NULL, NULL, NULL);

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
