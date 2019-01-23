-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 13 Gru 2018, 09:07
-- Wersja serwera: 10.1.37-MariaDB
-- Wersja PHP: 7.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `test`
--

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `faktury`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `faktury` (
`faktura` int(11) unsigned
,`symbol` varchar(10)
,`netto` decimal(32,2)
,`podatek` decimal(36,2)
,`brutto` decimal(37,2)
,`pozycja` bigint(21)
,`towarów` bigint(21)
,`towarów_netto` decimal(32,2)
,`towarów_brutto` decimal(37,2)
,`usług` bigint(21)
,`usłeg_netto` decimal(32,2)
,`usłeg_brutto` decimal(37,2)
,`data` date
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `faktury_pozycje`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `faktury_pozycje` (
`id` int(11) unsigned
,`id_faktury` int(11) unsigned
,`pozycja` int(11) unsigned
,`symbol_faktury` varchar(10)
,`netto` decimal(10,2)
,`brutto` decimal(15,2)
,`podatek_wartość` decimal(14,2)
,`podatek_procent` tinyint(3)
,`data_faktury` date
,`rodzaj` varchar(6)
,`nazwa` varchar(32)
);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) UNSIGNED NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `invoices`
--

INSERT INTO `invoices` (`id`, `symbol`, `date`) VALUES
(1, '1/2018', '2018-01-11'),
(2, '2/2018', '2018-01-24'),
(3, '3/2018', '2018-02-14'),
(4, '4/2018', '2018-03-21'),
(5, '5/2018', '2018-05-30');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `invoices_position`
--

CREATE TABLE `invoices_position` (
  `id` int(11) UNSIGNED NOT NULL,
  `invoice_id` int(11) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL,
  `netto` decimal(10,2) NOT NULL,
  `tax` tinyint(3) NOT NULL DEFAULT '23',
  `is_service` tinyint(3) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Zrzut danych tabeli `invoices_position`
--

INSERT INTO `invoices_position` (`id`, `invoice_id`, `name`, `netto`, `tax`, `is_service`) VALUES
(1, 1, 'Zderzak', '950.30', 23, 0),
(2, 1, 'Grill', '630.99', 23, 0),
(3, 1, 'Reflektor', '204.00', 23, 0),
(4, 1, 'Usługa montażu', '800.00', 23, 1),
(5, 1, 'Usługa lakiernicza', '1000.00', 8, 1),
(6, 2, 'Fotel pasażera', '1400.20', 23, 0),
(7, 2, 'Fotel kierowcy', '1730.00', 23, 0),
(8, 2, 'Usługi tapicerskie', '500.00', 18, 1),
(9, 2, 'Usługa montażu', '450.00', 23, 1),
(10, 2, 'Skóra', '1200.00', 23, 0),
(11, 2, 'Śruby mocujące', '125.49', 23, 0),
(12, 3, 'Diagnostyka', '100.00', 23, 1),
(13, 3, 'Programowanie sterownika', '520.00', 18, 1),
(14, 4, 'Olej silnikowy 10w40 5l', '120.00', 23, 0),
(15, 4, 'Uszczelka miski olejowej', '66.98', 23, 0),
(16, 5, 'Zwrot zaliczki za usługę', '-500.00', 0, 1),
(17, 5, 'Naklejka', '10.00', 2, 0);

-- --------------------------------------------------------

--
-- Struktura widoku `faktury`
--
DROP TABLE IF EXISTS `faktury`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `faktury`  AS  select `invoices`.`id` AS `faktura`,`invoices`.`symbol` AS `symbol`,sum(`invoices_position`.`netto`) AS `netto`,sum(round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2)) AS `podatek`,(sum(`invoices_position`.`netto`) + sum(round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2))) AS `brutto`,count(`invoices_position`.`invoice_id`) AS `pozycja`,count(if((`invoices_position`.`is_service` = 0),`invoices_position`.`is_service`,NULL)) AS `towarów`,sum(if((`invoices_position`.`is_service` = 0),`invoices_position`.`netto`,0)) AS `towarów_netto`,(sum(if((`invoices_position`.`is_service` = 0),round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2),0)) + sum(if((`invoices_position`.`is_service` = 0),`invoices_position`.`netto`,0))) AS `towarów_brutto`,count(if((`invoices_position`.`is_service` = 1),`invoices_position`.`is_service`,NULL)) AS `usług`,sum(if((`invoices_position`.`is_service` = 1),`invoices_position`.`netto`,0)) AS `usłeg_netto`,(sum(if((`invoices_position`.`is_service` = 1),round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2),0)) + sum(if((`invoices_position`.`is_service` = 1),`invoices_position`.`netto`,0))) AS `usłeg_brutto`,`invoices`.`date` AS `data` from (`invoices` join `invoices_position`) where (`invoices`.`id` = `invoices_position`.`invoice_id`) group by `invoices_position`.`invoice_id` ;

-- --------------------------------------------------------

--
-- Struktura widoku `faktury_pozycje`
--
DROP TABLE IF EXISTS `faktury_pozycje`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `faktury_pozycje`  AS  select `invoices_position`.`id` AS `id`,`invoices_position`.`invoice_id` AS `id_faktury`,`invoices_position`.`id` AS `pozycja`,`invoices`.`symbol` AS `symbol_faktury`,`invoices_position`.`netto` AS `netto`,(round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2) + `invoices_position`.`netto`) AS `brutto`,round(((`invoices_position`.`netto` * `invoices_position`.`tax`) / 100),2) AS `podatek_wartość`,`invoices_position`.`tax` AS `podatek_procent`,`invoices`.`date` AS `data_faktury`,if((`invoices_position`.`is_service` = 1),'USŁUGA','TOWAR') AS `rodzaj`,`invoices_position`.`name` AS `nazwa` from (`invoices` join `invoices_position`) group by `invoices_position`.`id` ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `invoices_position`
--
ALTER TABLE `invoices_position`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `is_service` (`is_service`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `invoices_position`
--
ALTER TABLE `invoices_position`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `invoices_position`
--
ALTER TABLE `invoices_position`
  ADD CONSTRAINT `invoices_position_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
