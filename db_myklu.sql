-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 16 Mar 2022 pada 07.44
-- Versi server: 10.4.8-MariaDB
-- Versi PHP: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_myklu`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `keluhan`
--

CREATE TABLE `keluhan` (
  `id` int(11) NOT NULL,
  `keluhan` text DEFAULT NULL,
  `image` text NOT NULL,
  `fakultas` text DEFAULT NULL,
  `penerima` text DEFAULT NULL,
  `tipe` text DEFAULT NULL,
  `tindakan` text DEFAULT NULL,
  `stat` text DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `createDate` date DEFAULT NULL,
  `idUsers` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `keluhan`
--

INSERT INTO `keluhan` (`id`, `keluhan`, `image`, `fakultas`, `penerima`, `tipe`, `tindakan`, `stat`, `feedback`, `createDate`, `idUsers`) VALUES
(1, 'Air di asrama kotor, tolong dibersihkan. Terimakasih', '', 'defg', 'Bagian Asrama', 'tes', 'tes', 'open', 'tes', '2021-09-26', 7),
(33, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', '26102021075546scaled_image_picker2049639524390529279.jpg', '', '', 'tes', '', 'open', '', '2021-10-26', 7),
(51, 'ziggy', '04012022080412scaled_image_picker4853956451384303671.jpg', '', '', 'Keluhan', '', '', '', '2022-01-04', 10),
(64, 'tes', '23022022122435scaled_image_picker8219130693616108918.jpg', '', '', 'Masukan', '', '', '', '2022-02-23', 9);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` text DEFAULT NULL,
  `password` text DEFAULT NULL,
  `nama` text DEFAULT NULL,
  `nim` int(11) DEFAULT NULL,
  `createdDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `nama`, `nim`, `createdDate`) VALUES
(7, 'yasrilrais', '0997c3244d0a90159660f56f8808e6ac', 'Muhammad Yasril Rais', 1103174179, '2021-09-25 18:40:57'),
(9, 'ari', 'fc292bd7df071858c2d0f955545673c1', 'Fachri M', 1103179174, '2021-10-03 15:33:58'),
(10, 'edus', '45d3d899d59b56a04e566f1c97195be8', 'Ziggy Zeordygaexcelsazabriskie', 1103176173, '2021-12-13 14:27:57');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idUsers` (`idUsers`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `keluhan`
--
ALTER TABLE `keluhan`
  ADD CONSTRAINT `keluhan_ibfk_1` FOREIGN KEY (`idUsers`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
