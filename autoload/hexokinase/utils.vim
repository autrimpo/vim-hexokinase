let s:hexadecimals = ['0', '1', '2', '3',
                    \ '4', '5', '6', '7',
                    \ '8', '9', 'A', 'B',
                    \ 'C', 'D', 'E', 'F']

fun! hexokinase#utils#build_pattern(patternsList) abort
  return '\%\(' . join(a:patternsList, '\|') . '\)'
endf

" rgbList should be a list of numbers
fun! hexokinase#utils#rgb_to_hex(rgbList) abort
  let r = a:rgbList[0]
  let g = a:rgbList[1]
  let b = a:rgbList[2]
  let hex = '#'
  let hex .= s:hexadecimals[r / 16]
  let hex .= s:hexadecimals[r % 16]
  let hex .= s:hexadecimals[g / 16]
  let hex .= s:hexadecimals[g % 16]
  let hex .= s:hexadecimals[b / 16]
  let hex .= s:hexadecimals[b % 16]
  return hex
endf

" returns a list of numbers
fun! hexokinase#utils#hex_to_rgb(hex) abort
  let raw_hex = [0, 0, 0, 0, 0, 0]
  for i in range(1, 6)
    let raw_hex[i - 1] = index(s:hexadecimals, a:hex[i])
  endfor
  let r = (raw_hex[0] * 16) + raw_hex[1]
  let g = (raw_hex[2] * 16) + raw_hex[3]
  let b = (raw_hex[4] * 16) + raw_hex[5]
  return [r, g, b]
endf

fun! hexokinase#utils#get_background_rgb() abort
  return hexokinase#utils#hex_to_rgb(hexokinase#utils#get_background_hex())
endf

fun! hexokinase#utils#get_background_hex() abort
  if index(g:Hexokinase_highlighters, 'virtual') >= 0
        \ || index(g:Hexokinase_highlighters, 'sign_column') >= 0
        \ || empty(synIDattr(hlID('SignColumn'), 'bg'))
    return synIDattr(hlID('Normal'), 'bg')
  else index(g:Hexokinase_highlighters, 'sign_column') >= 0
    return synIDattr(hlID('SignColumn'), 'bg')
  endif
endf

fun! hexokinase#utils#valid_rgb(rgbList) abort
  let [r, g, b] = a:rgbList
  if r > 255 || r < 0 || g > 255 || g < 0 || b > 255 || b < 0
    return 0
  else
    return 1
  endif
endf

fun! hexokinase#utils#apply_alpha_to_rgb(primary_rgb, alpha) abort
  let [bg_r, bg_g, bg_b] = hexokinase#utils#get_background_rgb()
  let [old_r, old_g, old_b] = a:primary_rgb

  let new_r = float2nr(bg_r + ((old_r - bg_r) * a:alpha))
  let new_g = float2nr(bg_g + ((old_g - bg_g) * a:alpha))
  let new_b = float2nr(bg_b + ((old_b - bg_b) * a:alpha))
  return [new_r, new_g, new_b]
endf
