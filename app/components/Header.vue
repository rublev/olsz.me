<template>
  <header
    class="
      fixed right-4 bottom-4 left-4 flex max-w-[375px] justify-center gap-2
      rounded-full bg-white p-4 text-black
    "
  >
    <a href="/" class="flex items-center border border-red-500">
      <Icon name="svg:logo-color" class="h-[22px] w-[37px]" />
    </a>
    <nav class="flex items-center border border-red-500">
      <a href="/resume" class="">
        Resume
      </a>
      <a href="/contact" class="">
        Contact
      </a>
    </nav>
    <nav class="flex items-center border border-red-500">
      <a href="#" target="_blank" class="">
        10x
      </a>
      <a
        href="https://linkedin.com/in/marcelolszewski"
        target="_blank"
        class=""
      >
        <Icon name="mdi:linkedin" mode="css" class="h-4 w-4" />
        LinkedIn
      </a>
      <a
        href="https://github.com/marcelolszewski"
        target="_blank"
        class=""
      >
        <Icon name="mdi:github" mode="css" class="h-4 w-4" />
        GitHub
      </a>
    </nav>
  </header>
</template>
