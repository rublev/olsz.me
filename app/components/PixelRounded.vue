<template>
  <div class="pixel-rounded">
    <slot />
  </div>
</template>

<style scoped>
.pixel-rounded {
  overflow: hidden;
  display: inline-block;
  /* Required for clip-path to work reliably */
  width: fit-content;
  height: fit-content;
  /* The clip-path straight from the blog post */
  clip-path: polygon(
    0px 20px,
    4px 20px,
    4px 12px,
    8px 12px,
    8px 8px,
    12px 8px,
    12px 4px,
    16px 4px,
    20px 4px,
    20px 0px,
    calc(100% - 20px) 0px,
    calc(100% - 20px) 4px,
    calc(100% - 12px) 4px,
    calc(100% - 12px) 8px,
    calc(100% - 8px) 8px,
    calc(100% - 8px) 12px,
    calc(100% - 4px) 12px,
    calc(100% - 4px) 16px,
    calc(100% - 4px) 20px,
    100% 20px,
    100% calc(100% - 20px),
    calc(100% - 4px) calc(100% - 20px),
    calc(100% - 4px) calc(100% - 12px),
    calc(100% - 8px) calc(100% - 12px),
    calc(100% - 8px) calc(100% - 8px),
    calc(100% - 12px) calc(100% - 8px),
    calc(100% - 12px) calc(100% - 4px),
    calc(100% - 16px) calc(100% - 4px),
    calc(100% - 20px) calc(100% - 4px),
    calc(100% - 20px) 100%,
    20px 100%,
    20px calc(100% - 4px),
    12px calc(100% - 4px),
    12px calc(100% - 8px),
    8px calc(100% - 8px),
    8px calc(100% - 12px),
    4px calc(100% - 12px),
    4px calc(100% - 16px),
    4px calc(100% - 20px),
    0px calc(100% - 20px)
  );
}
</style>
