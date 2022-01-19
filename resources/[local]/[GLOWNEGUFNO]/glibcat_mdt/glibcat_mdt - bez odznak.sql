ALTER TABLE `users`
ADD COLUMN `kartoteka_avatar` VARCHAR(50) DEFAULT NULL;

--
-- Struktura tabeli dla tabeli `kartoteka_notatki`
--

CREATE TABLE `kartoteka_notatki` (
  `identifier` varchar(100) NOT NULL,
  `note` text NOT NULL,
  `policjant` varchar(50) NOT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tablet_notatki`
--

CREATE TABLE `tablet_notatki` (
  `identifier` varchar(100) NOT NULL,
  `notatka` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tablet_ogloszenia`
--

CREATE TABLE `tablet_ogloszenia` (
  `ogloszenie` text NOT NULL,
  `policjant` varchar(50) NOT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tablet_ogloszenia_seen`
--

CREATE TABLE `tablet_ogloszenia_seen` (
  `identifier` varchar(100) NOT NULL,
  `seen` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `user_kartoteka`
--

CREATE TABLE `user_kartoteka` (
  `identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `policjant` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `powod` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `grzywna` int(11) DEFAULT NULL,
  `ilosc_lat` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- --------------------------------------------------------


--
-- Struktura tabeli dla tabeli `user_poszukiwania`
--

CREATE TABLE `user_poszukiwania` (
  `identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `policjant` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `powod` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pojazd` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tablet_raporty`
--

CREATE TABLE `tablet_raporty` (
  `identifier` varchar(100) NOT NULL,
  `raport` text NOT NULL,
  `policjant` varchar(50) NOT NULL,
  `data` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
