export default defineNuxtPlugin(() => {
  // Initialize theme before hydration to prevent flash
  const { initTheme } = useTheme()
  initTheme()
})
