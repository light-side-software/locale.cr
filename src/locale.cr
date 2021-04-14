lib LibC
  # These are the possibilities for the first argument to setlocale.
  # The code assumes that the lowest LC_* symbol has the value zero.
  LC_CTYPE = 0
  LC_NUMERIC = 1
  LC_TIME = 2
  LC_COLLATE = 3
  LC_MONETARY = 4
  LC_MESSAGES = 5
  LC_ALL = 6
  LC_PAPER = 7
  LC_NAME = 8
  LC_ADDRESS = 9
  LC_TELEPHONE = 10
  LC_MEASUREMENT = 11
  LC_IDENTIFICATION = 12

  # Structure giving information about numeric and monetary notation.
  struct LConv
    # Numeric (non-monetary) information.
    decimal_point : UInt8* # Decimal point character.
    thousands_sep : UInt8* # Thousands separator.
    # Each element is the number of digits in each group;
    # elements with higher indices are farther left.
    # An element with value CHAR_MAX means that no further grouping is done.
    # An element with value 0 means that the previous element is used
    # for all groups farther left.
    grouping : UInt8*

    # Monetary information.

    # First three chars are a currency symbol from ISO 4217.
    # Fourth char is the separator.  Fifth char is '\0'.
    int_curr_symbol : UInt8*
    currency_symbol : UInt8* # Local currency symbol.
    mon_decimal_point : UInt8* # Decimal point character.
    mon_thousands_sep : UInt8* # Thousands separator.
    mon_grouping : UInt8* # Like `grouping' element (above).
    positive_sign : UInt8* # Sign for positive values.
    negative_sign : UInt8* # Sign for negative values.
    int_frac_digits : UInt8 # Int'l fractional digits.
    frac_digits : UInt8 # Local fractional digits.
    # 1 if currency_symbol precedes a positive value, 0 if succeeds.
    p_cs_precedes : UInt8
    # 1 iff a space separates currency_symbol from a positive value.
    p_sep_by_space : UInt8
    # 1 if currency_symbol precedes a negative value, 0 if succeeds.
    n_cs_precedes : UInt8
    # 1 iff a space separates currency_symbol from a negative value.
    n_sep_by_space : UInt8
    # Positive and negative sign positions:
    # 0 Parentheses surround the quantity and currency_symbol.
    # 1 The sign string precedes the quantity and currency_symbol.
    # 2 The sign string follows the quantity and currency_symbol.
    # 3 The sign string immediately precedes the currency_symbol.
    # 4 The sign string immediately follows the currency_symbol.
    p_sign_posn : UInt8
    n_sign_posn : UInt8

    # 1 if int_curr_symbol precedes a positive value, 0 if succeeds.
    int_p_cs_precedes : UInt8
    # 1 iff a space separates int_curr_symbol from a positive value.
    int_p_sep_by_space : UInt8
    # 1 if int_curr_symbol precedes a negative value, 0 if succeeds.
    int_n_cs_precedes : UInt8
    # 1 iff a space separates int_curr_symbol from a negative value.
    int_n_sep_by_space : UInt8
    # Positive and negative sign positions:
    # 0 Parentheses surround the quantity and int_curr_symbol.
    # 1 The sign string precedes the quantity and int_curr_symbol.
    # 2 The sign string follows the quantity and int_curr_symbol.
    # 3 The sign string immediately precedes the int_curr_symbol.
    # 4 The sign string immediately follows the int_curr_symbol.
    int_p_sign_posn : UInt8
    int_n_sign_posn : UInt8
  end

  # Set and/or return the current locale.
  fun setlocale(category : Int32, locale : UInt8*) : UInt8*

  # Return the numeric/monetary information for the current locale.
  fun localeconv() : LConv*

  struct LocaleStruct
    # Note: LC_ALL is not a valid index into this array.
    locales : Int32*[13]

    # To increase the speed of this solution we add some special members.
    ctype_b : UInt16*
    ctype_tolower : Int32*
    ctype_toupper : Int32*

    # Note: LC_ALL is not a valid index into this array.
    names : UInt8*[13]
  end

  alias LocalT = LocaleStruct*

  # Return a reference to a data structure representing a set of locale
  # datasets.  Unlike for the CATEGORY parameter for `setlocale' the
  # CATEGORY_MASK parameter here uses a single bit for each category,
  # made by OR'ing together LC_*_MASK bits above.
  fun newlocale(category_mask : Int32, locale : UInt8*, base : LocalT) : LocalT

  # These are the bits that can be set in the CATEGORY_MASK argument to
  # `newlocale'.  In the GNU implementation, LC_FOO_MASK has the value
  # of (1 << LC_FOO), but this is not a part of the interface that
  # callers can assume will be true.
  LC_CTYPE_MASK = 1 << LC_CTYPE
  LC_NUMERIC_MASK = 1 << LC_NUMERIC
  LC_TIME_MASK = 1 << LC_TIME
  LC_COLLATE_MASK = 1 << LC_COLLATE
  LC_MONETARY_MASK = 1 << LC_MONETARY
  LC_MESSAGES_MASK = 1 << LC_MESSAGES
  LC_PAPER_MASK = 1 << LC_PAPER
  LC_NAME_MASK = 1 << LC_NAME
  LC_ADDRESS_MASK = 1 << LC_ADDRESS
  LC_TELEPHONE_MASK = 1 << LC_TELEPHONE
  LC_MEASUREMENT_MASK = 1 << LC_MEASUREMENT
  LC_IDENTIFICATION_MASK = 1 << LC_IDENTIFICATION
  LC_ALL_MASK = LC_CTYPE_MASK |
                LC_NUMERIC_MASK |
                LC_TIME_MASK |
                LC_COLLATE_MASK |
                LC_MONETARY_MASK |
                LC_MESSAGES_MASK |
                LC_PAPER_MASK |
                LC_NAME_MASK |
                LC_ADDRESS_MASK |
                LC_TELEPHONE_MASK |
                LC_MEASUREMENT_MASK |
                LC_IDENTIFICATION_MASK

  # Return a duplicate of the set of locale in DATASET.  All usage
  #    counters are increased if necessary.
  fun duplocale(dataset : LocalT) : LocalT

  # Free the data associated with a locale dataset previously returned
  # by a call to `setlocale_r`.
  fun freelocale(dataset : LocalT) : Void

  # Switch the current thread's locale to DATASET.
  # If DATASET is null, instead just return the current setting.
  # The special value LC_GLOBAL_LOCALE is the initial setting
  # for all threads and can also be installed any time, meaning
  # the thread uses the global settings controlled by `setlocale`.
  fun uselocale(dataset : LocalT) : LocalT

  # This value can be passed to `uselocale' and may be returned by it.
  # Passing this value to any other function has undefined behavior.
  LC_GLOBAL_LOCALE = -1_i64.unsafe_as(LocalT)
end

module Locale
  VERSION = "1.0.0"

  # Set and/or return the current locale.
  def self.set_locale(category : Int32, locale : String) : String
    String.new(LibC.setlocale(category, locale.to_unsafe))
  end

  # Wrapper for LibC::LConv struct
  struct LocalConventions
    # Numeric (non-monetary) information.
    # Decimal point character.
    getter decimal_point : String

    # Thousands separator.
    getter thousands_sep : String

    # Each element is the number of digits in each group;
    # elements with higher indices are farther left.
    # An element with value CHAR_MAX means that no further grouping is done.
    # An element with value 0 means that the previous element is used
    # for all groups farther left.
    getter grouping : Array(UInt8)

    # Monetary information.

    # First three chars are a currency symbol from ISO 4217.
    # Fourth char is the separator.  Fifth char is '\0'.
    getter int_curr_symbol : String

    # Local currency symbol.
    getter currency_symbol : String

    # Decimal point character.
    getter mon_decimal_point : String

    # Thousands separator.
    getter mon_thousands_sep : String

    # Like `grouping` element (above).
    getter mon_grouping : Array(UInt8)

    # Sign for positive values.
    getter positive_sign : String

    # Sign for negative values.
    getter negative_sign : String

    # Int'l fractional digits.
    getter int_frac_digits : UInt8

    # Local fractional digits.
    getter frac_digits : UInt8

    # 1 if currency_symbol precedes a positive value, 0 if succeeds.
    getter p_cs_precedes : UInt8

    # 1 if a space separates currency_symbol from a positive value.
    getter p_sep_by_space : UInt8

    # 1 if currency_symbol precedes a negative value, 0 if succeeds.
    getter n_cs_precedes : UInt8

    # 1 if a space separates currency_symbol from a negative value.
    getter n_sep_by_space : UInt8

    # Positive and negative sign positions:
    # 0 Parentheses surround the quantity and currency_symbol.
    # 1 The sign string precedes the quantity and currency_symbol.
    # 2 The sign string follows the quantity and currency_symbol.
    # 3 The sign string immediately precedes the currency_symbol.
    # 4 The sign string immediately follows the currency_symbol.
    getter p_sign_posn : UInt8
    getter n_sign_posn : UInt8

    # 1 if int_curr_symbol precedes a positive value, 0 if succeeds.
    getter int_p_cs_precedes : UInt8

    # 1 if a space separates int_curr_symbol from a positive value.
    getter int_p_sep_by_space : UInt8

    # 1 if int_curr_symbol precedes a negative value, 0 if succeeds.
    getter int_n_cs_precedes : UInt8

    # 1 if a space separates int_curr_symbol from a negative value.
    getter int_n_sep_by_space : UInt8

    # Positive and negative sign positions:
    # 0 Parentheses surround the quantity and int_curr_symbol.
    # 1 The sign string precedes the quantity and int_curr_symbol.
    # 2 The sign string follows the quantity and int_curr_symbol.
    # 3 The sign string immediately precedes the int_curr_symbol.
    # 4 The sign string immediately follows the int_curr_symbol.
    getter int_p_sign_posn : UInt8
    getter int_n_sign_posn : UInt8

    def initialize(lconv : ::LibC::LConv)
      @decimal_point = String.new(lconv.decimal_point)
      @thousands_sep = String.new(lconv.thousands_sep)
      @grouping = [] of UInt8
      p = lconv.grouping
      while p.value != 0
        @grouping.push(p.value)
        p += 1
      end
      @int_curr_symbol = String.new(lconv.int_curr_symbol)
      @currency_symbol = String.new(lconv.currency_symbol)
      @mon_decimal_point = String.new(lconv.mon_decimal_point)
      @mon_thousands_sep = String.new(lconv.mon_thousands_sep)
      @mon_grouping = [] of UInt8
      p = lconv.mon_grouping
      while p.value != 0
        @mon_grouping.push(p.value)
        p += 1
      end
      @positive_sign = String.new(lconv.positive_sign)
      @negative_sign = String.new(lconv.negative_sign)
      @int_frac_digits = lconv.int_frac_digits
      @frac_digits = lconv.frac_digits
      @p_cs_precedes = lconv.p_cs_precedes
      @p_sep_by_space = lconv.p_sep_by_space
      @n_cs_precedes = lconv.n_cs_precedes
      @n_sep_by_space = lconv.n_sep_by_space
      @p_sign_posn = lconv.p_sign_posn
      @n_sign_posn = lconv.n_sign_posn
      @int_p_cs_precedes = lconv.int_p_cs_precedes
      @int_p_sep_by_space = lconv.int_p_sep_by_space
      @int_n_cs_precedes = lconv.int_n_cs_precedes
      @int_n_sep_by_space = lconv.int_n_sep_by_space
      @int_p_sign_posn = lconv.int_p_sign_posn
      @int_n_sign_posn = lconv.int_n_sign_posn
    end
  end

  def self.localeconv : LocalConventions
    LocalConventions.new(::LibC.localeconv.value)
  end
end
