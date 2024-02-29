extern "C" {
  unsigned __stdcall GetConsoleCP() noexcept;
  unsigned __stdcall GetConsoleOutputCP() noexcept;
  int __stdcall SetConsoleCP(unsigned) noexcept;
  int __stdcall SetConsoleOutputCP(unsigned) noexcept;
}

struct __libwin32_cp949_t {
  unsigned saved_input_cp;
  unsigned saved_output_cp;

  __libwin32_cp949_t() noexcept {
    saved_input_cp = GetConsoleCP();
    saved_output_cp = GetConsoleOutputCP();
    SetConsoleCP(949);
    SetConsoleOutputCP(949);
  }

  ~__libwin32_cp949_t() noexcept {
    SetConsoleCP(saved_input_cp);
    SetConsoleOutputCP(saved_output_cp);
  }
} __libwin32_cp949;
