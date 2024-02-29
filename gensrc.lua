#!/usr/bin/env lua

cpinfo = require("cpinfo")

codeTemplate = [[
extern "C" {
  unsigned __stdcall GetConsoleCP() noexcept;
  unsigned __stdcall GetConsoleOutputCP() noexcept;
  int __stdcall SetConsoleCP(unsigned) noexcept;
  int __stdcall SetConsoleOutputCP(unsigned) noexcept;
}

struct __libwin32_cp${cp}_t {
  unsigned saved_input_cp;
  unsigned saved_output_cp;

  __libwin32_cp${cp}_t() noexcept {
    saved_input_cp = GetConsoleCP();
    saved_output_cp = GetConsoleOutputCP();
    SetConsoleCP(${cp});
    SetConsoleOutputCP(${cp});
  }

  ~__libwin32_cp${cp}_t() noexcept {
    SetConsoleCP(saved_input_cp);
    SetConsoleOutputCP(saved_output_cp);
  }
} __libwin32_cp${cp};
]]

rcTemplate = [[
#include <winuser.h>

CREATEPROCESS_MANIFEST_RESOURCE_ID RT_MANIFEST "libwin32_cp${cp}_manifest.xml"
]]

manifestTemplate = [[
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly manifestVersion="1.0" xmlns="urn:schemas-microsoft-com:asm.v1">
  <assemblyIdentity type="win32" name="..." version="6.0.0.0"/>
  <application>
    <windowsSettings>
      <activeCodePage xmlns="http://schemas.microsoft.com/SMI/2019/WindowsSettings">${name}</activeCodePage>
    </windowsSettings>
  </application>
</assembly>
]]

for _, info in ipairs(cpinfo) do
  local cp, name = table.unpack(info)

  local code = codeTemplate:gsub("${cp}", cp)
  local codeFile = "src/libwin32_cp" .. cp .. "_init.cpp"
  io.open(codeFile, "w"):write(code):close()

  local rc = rcTemplate:gsub("${cp}", cp)
  local rcFile = "src/libwin32_cp" .. cp .. "_manifest.rc"
  io.open(rcFile, "w"):write(rc):close()

  local manifest = manifestTemplate:gsub("${cp}", cp):gsub("${name}", name)
  local manifestFile = "src/libwin32_cp" .. cp .. "_manifest.xml"
  io.open(manifestFile, "w"):write(manifest):close()
end
