<script setup></script>

<template>
  <header
    class="
      fixed bottom-0 z-100 mx-auto flex w-full max-w-[680px] flex-col
      items-center justify-between bg-black py-3
      before:pointer-events-none before:absolute before:top-[-20px]
      before:right-0 before:left-0 before:h-5 before:bg-gradient-to-t
      before:from-black before:to-transparent
      md:flex-row
    "
  >
    <nav class="flex items-center gap-6">
      <a
        href="/"
        class="
          flex items-center justify-center opacity-80 transition-opacity
          hover:opacity-100
        "
      >
        <Icon name="svg:logo-color" class="h-[22px] w-[37px]" />
      </a>
      <a
        href="/resume"
        class="
          rounded-md px-2 py-1 text-sm font-bold text-gray-400 transition-colors
          hover:bg-gray-800 hover:text-white
        "
      >Resume</a>
      <a
        href="/contact"
        class="
          rounded-md px-2 py-1 text-sm font-bold text-gray-400 transition-colors
          hover:bg-gray-800 hover:text-white
        "
      >Contact</a>
    </nav>
    <nav
      class="
        mt-1 flex items-center gap-1
        md:mt-0
      "
    >
      <a
        href="#"
        target="_blank"
        class="
          rounded-md px-2 py-1 text-sm font-bold text-gray-600 transition-colors
          hover:bg-gray-800 hover:text-white
        "
      >10x</a>
      <a
        href="https://linkedin.com/in/marcelolszewski"
        target="_blank"
        class="
          rounded-md px-2 py-1 text-sm font-bold text-gray-600 transition-colors
          hover:bg-gray-800 hover:text-white
        "
      >LinkedIn</a>
      <a
        href="https://github.com/marcelolszewski"
        target="_blank"
        class="
          rounded-md px-2 py-1 text-sm font-bold text-gray-600 transition-colors
          hover:bg-gray-800 hover:text-white
        "
      >GitHub</a>
    </nav>
  </header>
</template>
