export function useTheme() {
  const isDark = useState('isDark', () => false)

  // Get OS theme preference
  const getOsTheme = () => {
    if (typeof window === 'undefined')
      return 'light'
    return window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light'
  }

  // Initialize theme (call this only once on client mount)
  const initTheme = () => {
    const saved = sessionStorage.getItem('theme')
    const osTheme = getOsTheme()

    // Use saved theme if exists, otherwise use OS preference
    const theme = saved || osTheme
    isDark.value = theme === 'dark'

    // Apply theme to DOM
    document.documentElement.classList.toggle('dark', isDark.value)
  }

  // Toggle theme with smart sessionStorage handling
  const toggleTheme = () => {
    isDark.value = !isDark.value
    const newTheme = isDark.value ? 'dark' : 'light'
    const osTheme = getOsTheme()

    // Only save to sessionStorage if overriding OS preference
    if (newTheme === osTheme) {
      sessionStorage.removeItem('theme')
    }
    else {
      sessionStorage.setItem('theme', newTheme)
    }

    // Apply theme to DOM
    document.documentElement.classList.toggle('dark', isDark.value)
  }

  return {
    isDark,
    toggleTheme,
    initTheme,
  }
}
