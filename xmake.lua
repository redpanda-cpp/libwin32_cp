add_rules("mode.release")
set_languages("cxx11")
add_cxxflags(
  "-Os",
  "-fno-exceptions",
  "-fno-rtti",
  "-nodefaultlibs",
  "-nostdlib")

includes("cpinfo.lua")

for _, info in ipairs(cpinfo) do
  local cp, name = table.unpack(info)

  target("win32_cp" .. cp)
    set_kind("static")
    add_files(
      "src/libwin32_cp" .. cp .. "_init.cpp",
      "src/libwin32_cp" .. cp .. "_manifest.rc")

end
