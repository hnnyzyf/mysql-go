package charset

type Collation struct {

	//the name of collation
	Name string

	//the code of collation
	ID uint8

	//the belonging of current collation
	Charset string

	//wether the deualt collation of a charset
	IsDefault bool
}

//the mysql collations
var collations = []*Collation{
	{"unknow00_general_ci", 0x00, "unknown", true},
	{"big5_chinese_ci", 0x01, "big5", true},
	{"latin2_czech_cs", 0x02, "latin2", false},
	{"dec8_swedish_ci", 0x03, "dec8", true},
	{"cp850_general_ci", 0x04, "cp850", true},
	{"latin1_german1_ci", 0x05, "latin1", false},
	{"hp8_english_ci", 0x06, "hp8", true},
	{"koi8r_general_ci", 0x07, "koi8r", true},
	{"latin1_swedish_ci", 0x08, "latin1", true},
	{"latin2_general_ci", 0x09, "latin2", true},
	{"swe7_swedish_ci", 0x0A, "swe7", true},
	{"ascii_general_ci", 0x0B, "ascii", true},
	{"ujis_japanese_ci", 0x0C, "ujis", true},
	{"sjis_japanese_ci", 0x0D, "sjis", true},
	{"cp1251_bulgarian_ci", 0x0E, "cp1251", false},
	{"latin1_danish_ci", 0x0F, "latin1", false},
	{"hebrew_general_ci", 0x10, "hebrew", true},
	{"unknow17_general_ci", 0x11, "unknown", false},
	{"tis620_thai_ci", 0x12, "tis620", true},
	{"euckr_korean_ci", 0x13, "euckr", true},
	{"latin7_estonian_cs", 0x14, "latin7", false},
	{"latin2_hungarian_ci", 0x15, "latin2", false},
	{"koi8u_general_ci", 0x16, "koi8u", true},
	{"cp1251_ukrainian_ci", 0x17, "cp1251", false},
	{"gb2312_chinese_ci", 0x18, "gb2312", true},
	{"greek_general_ci", 0x19, "greek", true},
	{"cp1250_general_ci", 0x1A, "cp1250", true},
	{"latin2_croatian_ci", 0x1B, "latin2", false},
	{"gbk_chinese_ci", 0x1C, "gbk", true},
	{"cp1257_lithuanian_ci", 0x1D, "cp1257", false},
	{"latin5_turkish_ci", 0x1E, "latin5", true},
	{"latin1_german2_ci", 0x1F, "latin1", false},
	{"armscii8_general_ci", 0x20, "armscii8", true},
	{"utf8_general_ci", 0x21, "utf8", true},
	{"cp1250_czech_cs", 0x22, "cp1250", false},
	{"ucs2_general_ci", 0x23, "ucs2", true},
	{"cp866_general_ci", 0x24, "cp866", true},
	{"keybcs2_general_ci", 0x25, "keybcs2", true},
	{"macce_general_ci", 0x26, "macce", true},
	{"macroman_general_ci", 0x27, "macroman", true},
	{"cp852_general_ci", 0x28, "cp852", true},
	{"latin7_general_ci", 0x29, "latin7", true},
	{"latin7_general_cs", 0x2A, "latin7", false},
	{"macce_bin", 0x2B, "macce", false},
	{"cp1250_croatian_ci", 0x2C, "cp1250", false},
	{"utf8mb4_general_ci", 0x2D, "utf8mb4", true},
	{"utf8mb4_bin", 0x2E, "utf8mb4", false},
	{"latin1_bin", 0x2F, "latin1", false},
	{"latin1_general_ci", 0x30, "latin1", false},
	{"latin1_general_cs", 0x31, "latin1", false},
	{"cp1251_bin", 0x32, "cp1251", false},
	{"cp1251_general_ci", 0x33, "cp1251", true},
	{"cp1251_general_cs", 0x34, "cp1251", false},
	{"macroman_bin", 0x35, "macroman", false},
	{"utf16_general_ci", 0x36, "utf16", true},
	{"utf16_bin", 0x37, "utf16", false},
	{"utf16le_general_ci", 0x38, "utf16le", true},
	{"cp1256_general_ci", 0x39, "cp1256", true},
	{"cp1257_bin", 0x3A, "cp1257", false},
	{"cp1257_general_ci", 0x3B, "cp1257", true},
	{"utf32_general_ci", 0x3C, "utf32", true},
	{"utf32_bin", 0x3D, "utf32", false},
	{"utf16le_bin", 0x3E, "utf16le", false},
	{"binary", 0x3F, "binary", true},
	{"armscii8_bin", 0x40, "armscii8", false},
	{"ascii_bin", 0x41, "ascii", false},
	{"cp1250_bin", 0x42, "cp1250", false},
	{"cp1256_bin", 0x43, "cp1256", false},
	{"cp866_bin", 0x44, "cp866", false},
	{"dec8_bin", 0x45, "dec8", false},
	{"greek_bin", 0x46, "greek", false},
	{"hebrew_bin", 0x47, "hebrew", false},
	{"hp8_bin", 0x48, "hp8", false},
	{"keybcs2_bin", 0x49, "keybcs2", false},
	{"koi8r_bin", 0x4A, "koi8r", false},
	{"koi8u_bin", 0x4B, "koi8u", false},
	{"latin2_bin", 0x4D, "latin2", false},
	{"latin5_bin", 0x4E, "latin5", false},
	{"latin7_bin", 0x4F, "latin7", false},
	{"cp850_bin", 0x50, "cp850", false},
	{"cp852_bin", 0x51, "cp852", false},
	{"swe7_bin", 0x52, "swe7", false},
	{"utf8_bin", 0x53, "utf8", false},
	{"big5_bin", 0x54, "big5", false},
	{"euckr_bin", 0x55, "euckr", false},
	{"gb2312_bin", 0x56, "gb2312", false},
	{"gbk_bin", 0x57, "gbk", false},
	{"sjis_bin", 0x58, "sjis", false},
	{"tis620_bin", 0x59, "tis620", false},
	{"ucs2_bin", 0x5A, "ucs2", false},
	{"ujis_bin", 0x5B, "ujis", false},
	{"geostd8_general_ci", 0x5C, "geostd8", true},
	{"geostd8_bin", 0x5D, "geostd8", false},
	{"latin1_spanish_ci", 0x5E, "latin1", false},
	{"cp932_japanese_ci", 0x5F, "cp932", true},
	{"cp932_bin", 0x60, "cp932", false},
	{"eucjpms_japanese_ci", 0x61, "eucjpms", true},
	{"eucjpms_bin", 0x62, "eucjpms", false},
	{"cp1250_polish_ci", 0x63, "cp1250", false},
	{"utf16_unicode_ci", 0x65, "utf16", false},
	{"utf16_icelandic_ci", 0x66, "utf16", false},
	{"utf16_latvian_ci", 0x67, "utf16", false},
	{"utf16_romanian_ci", 0x68, "utf16", false},
	{"utf16_slovenian_ci", 0x69, "utf16", false},
	{"utf16_polish_ci", 0x6A, "utf16", false},
	{"utf16_estonian_ci", 0x6B, "utf16", false},
	{"utf16_spanish_ci", 0x6C, "utf16", false},
	{"utf16_swedish_ci", 0x6D, "utf16", false},
	{"utf16_turkish_ci", 0x6E, "utf16", false},
	{"utf16_czech_ci", 0x6F, "utf16", false},
	{"utf16_danish_ci", 0x70, "utf16", false},
	{"utf16_lithuanian_ci", 0x71, "utf16", false},
	{"utf16_slovak_ci", 0x72, "utf16", false},
	{"utf16_spanish2_ci", 0x73, "utf16", false},
	{"utf16_roman_ci", 0x74, "utf16", false},
	{"utf16_persian_ci", 0x75, "utf16", false},
	{"utf16_esperanto_ci", 0x76, "utf16", false},
	{"utf16_hungarian_ci", 0x77, "utf16", false},
	{"utf16_sinhala_ci", 0x78, "utf16", false},
	{"utf16_german2_ci", 0x79, "utf16", false},
	{"utf16_croatian_ci", 0x7A, "utf16", false},
	{"utf16_unicode_520_ci", 0x7B, "utf16", false},
	{"utf16_vietnamese_ci", 0x7C, "utf16", false},
	{"ucs2_unicode_ci", 0x80, "ucs2", false},
	{"ucs2_icelandic_ci", 0x81, "ucs2", false},
	{"ucs2_latvian_ci", 0x82, "ucs2", false},
	{"ucs2_romanian_ci", 0x83, "ucs2", false},
	{"ucs2_slovenian_ci", 0x84, "ucs2", false},
	{"ucs2_polish_ci", 0x85, "ucs2", false},
	{"ucs2_estonian_ci", 0x86, "ucs2", false},
	{"ucs2_spanish_ci", 0x87, "ucs2", false},
	{"ucs2_swedish_ci", 0x88, "ucs2", false},
	{"ucs2_turkish_ci", 0x89, "ucs2", false},
	{"ucs2_czech_ci", 0x8A, "ucs2", false},
	{"ucs2_danish_ci", 0x8B, "ucs2", false},
	{"ucs2_lithuanian_ci", 0x8C, "ucs2", false},
	{"ucs2_slovak_ci", 0x8D, "ucs2", false},
	{"ucs2_spanish2_ci", 0x8E, "ucs2", false},
	{"ucs2_roman_ci", 0x8F, "ucs2", false},
	{"ucs2_persian_ci", 0x90, "ucs2", false},
	{"ucs2_esperanto_ci", 0x91, "ucs2", false},
	{"ucs2_hungarian_ci", 0x92, "ucs2", false},
	{"ucs2_sinhala_ci", 0x93, "ucs2", false},
	{"ucs2_german2_ci", 0x94, "ucs2", false},
	{"ucs2_croatian_ci", 0x95, "ucs2", false},
	{"ucs2_unicode_520_ci", 0x96, "ucs2", false},
	{"ucs2_vietnamese_ci", 0x97, "ucs2", false},
	{"ucs2_general_mysql500_ci", 0x9F, "ucs2", false},
	{"utf32_unicode_ci", 0xA0, "utf32", false},
	{"utf32_icelandic_ci", 0xA1, "utf32", false},
	{"utf32_latvian_ci", 0xA2, "utf32", false},
	{"utf32_romanian_ci", 0xA3, "utf32", false},
	{"utf32_slovenian_ci", 0xA4, "utf32", false},
	{"utf32_polish_ci", 0xA5, "utf32", false},
	{"utf32_estonian_ci", 0xA6, "utf32", false},
	{"utf32_spanish_ci", 0xA7, "utf32", false},
	{"utf32_swedish_ci", 0xA8, "utf32", false},
	{"utf32_turkish_ci", 0xA9, "utf32", false},
	{"utf32_czech_ci", 0xAA, "utf32", false},
	{"utf32_danish_ci", 0xAB, "utf32", false},
	{"utf32_lithuanian_ci", 0xAC, "utf32", false},
	{"utf32_slovak_ci", 0xAD, "utf32", false},
	{"utf32_spanish2_ci", 0xAE, "utf32", false},
	{"utf32_roman_ci", 0xAF, "utf32", false},
	{"utf32_persian_ci", 0xB0, "utf32", false},
	{"utf32_esperanto_ci", 0xB1, "utf32", false},
	{"utf32_hungarian_ci", 0xB2, "utf32", false},
	{"utf32_sinhala_ci", 0xB3, "utf32", false},
	{"utf32_german2_ci", 0xB4, "utf32", false},
	{"utf32_croatian_ci", 0xB5, "utf32", false},
	{"utf32_unicode_520_ci", 0xB6, "utf32", false},
	{"utf32_vietnamese_ci", 0xB7, "utf32", false},
	{"utf8_unicode_ci", 0xC0, "utf8", false},
	{"utf8_icelandic_ci", 0xC1, "utf8", false},
	{"utf8_latvian_ci", 0xC2, "utf8", false},
	{"utf8_romanian_ci", 0xC3, "utf8", false},
	{"utf8_slovenian_ci", 0xC4, "utf8", false},
	{"utf8_polish_ci", 0xC5, "utf8", false},
	{"utf8_estonian_ci", 0xC6, "utf8", false},
	{"utf8_spanish_ci", 0xC7, "utf8", false},
	{"utf8_swedish_ci", 0xC8, "utf8", false},
	{"utf8_turkish_ci", 0xC9, "utf8", false},
	{"utf8_czech_ci", 0xCA, "utf8", false},
	{"utf8_danish_ci", 0xCB, "utf8", false},
	{"utf8_lithuanian_ci", 0xCC, "utf8", false},
	{"utf8_slovak_ci", 0xCD, "utf8", false},
	{"utf8_spanish2_ci", 0xCE, "utf8", false},
	{"utf8_roman_ci", 0xCF, "utf8", false},
	{"utf8_persian_ci", 0xD0, "utf8", false},
	{"utf8_esperanto_ci", 0xD1, "utf8", false},
	{"utf8_hungarian_ci", 0xD2, "utf8", false},
	{"utf8_sinhala_ci", 0xD3, "utf8", false},
	{"utf8_german2_ci", 0xD4, "utf8", false},
	{"utf8_croatian_ci", 0xD5, "utf8", false},
	{"utf8_unicode_520_ci", 0xD6, "utf8", false},
	{"utf8_vietnamese_ci", 0xD7, "utf8", false},
	{"utf8_general_mysql500_ci", 0xDF, "utf8", false},
	{"utf8mb4_unicode_ci", 0xE0, "utf8mb4", false},
	{"utf8mb4_icelandic_ci", 0xE1, "utf8mb4", false},
	{"utf8mb4_latvian_ci", 0xE2, "utf8mb4", false},
	{"utf8mb4_romanian_ci", 0xE3, "utf8mb4", false},
	{"utf8mb4_slovenian_ci", 0xE4, "utf8mb4", false},
	{"utf8mb4_polish_ci", 0xE5, "utf8mb4", false},
	{"utf8mb4_estonian_ci", 0xE6, "utf8mb4", false},
	{"utf8mb4_spanish_ci", 0xE7, "utf8mb4", false},
	{"utf8mb4_swedish_ci", 0xE8, "utf8mb4", false},
	{"utf8mb4_turkish_ci", 0xE9, "utf8mb4", false},
	{"utf8mb4_czech_ci", 0xEA, "utf8mb4", false},
	{"utf8mb4_danish_ci", 0xEB, "utf8mb4", false},
	{"utf8mb4_lithuanian_ci", 0xEC, "utf8mb4", false},
	{"utf8mb4_slovak_ci", 0xED, "utf8mb4", false},
	{"utf8mb4_spanish2_ci", 0xEE, "utf8mb4", false},
	{"utf8mb4_roman_ci", 0xEF, "utf8mb4", false},
	{"utf8mb4_persian_ci", 0xF0, "utf8mb4", false},
	{"utf8mb4_esperanto_ci", 0xF1, "utf8mb4", false},
	{"utf8mb4_hungarian_ci", 0xF2, "utf8mb4", false},
	{"utf8mb4_sinhala_ci", 0xF3, "utf8mb4", false},
	{"utf8mb4_german2_ci", 0xF4, "utf8mb4", false},
	{"utf8mb4_croatian_ci", 0xF5, "utf8mb4", false},
	{"utf8mb4_unicode_520_ci", 0xF6, "utf8mb4", false},
	{"utf8mb4_vietnamese_ci", 0xF7, "utf8mb4", false},
	{"gb18030_chinese_ci", 0xF8, "gb18030", true},
	{"gb18030_bin", 0xF9, "gb18030", false},
	{"gb18030_unicode_520_ci", 0xFA, "gb18030", false},
}
