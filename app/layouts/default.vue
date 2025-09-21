<script setup></script>

<template>
  <div
    class="flex min-h-screen flex-col-reverse"
  >
    <Header />
    <main class="min-h-screen flex-grow p-4">
      <slot />
    </main>
    <Footer class="mt-auto" />
  </div>
</template>
