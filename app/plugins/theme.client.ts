export default defineNuxtPlugin(() => {
  // run immediately before hydration
  const savedTheme = sessionStorage.getItem('theme')

  if (savedTheme === 'dark') {
    document.documentElement.classList.add('dark')
  }
  else if (savedTheme === 'light') {
    document.documentElement.classList.remove('dark')
  }
  else {
    // no saved theme so use system
    const systemPrefersDark = window.matchMedia(
      '(prefers-color-scheme: dark)',
    ).matches
    if (systemPrefersDark) {
      document.documentElement.classList.add('dark')
    }
    else {
      document.documentElement.classList.remove('dark')
    }
  }
})
