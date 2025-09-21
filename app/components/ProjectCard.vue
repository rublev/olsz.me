<script setup>
defineProps({
  href: {
    type: String,
    required: true,
  },
  title: {
    type: String,
    required: true,
  },
  initials: {
    type: String,
    required: true,
  },
  iconBgClass: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    required: true,
  },
  period: {
    type: String,
    required: true,
  },
})
</script>

<template>
  <a
    :href="href"
    target="_blank"
    class="
      flex min-w-full flex-1 flex-col rounded-lg border border-white/15 p-4
      transition-all duration-700 ease-out
      hover:z-10 hover:-translate-y-2 hover:rotate-[-1.142deg]
      hover:skew-x-[-3.142deg] hover:cursor-alias hover:border
      hover:border-white hover:bg-transparent
      hover:shadow-[2px_2px_0px_0px_rgb(255,255,255),2px_3px_0px_0px_rgb(255,255,255)]
      sm:h-[180px] sm:min-w-[198px]
    "
  >
    <div class="mb-6 flex items-center gap-4">
      <span class="text-lg font-semibold text-white">{{ title }}</span>
    </div>
    <div class="mt-auto flex flex-col">
      <p class="text-sm text-gray-200">{{ role }}</p>
      <span class="mt-2 font-mono text-xs text-gray-300">{{ period }}</span>
    </div>
  </a>
</template>
