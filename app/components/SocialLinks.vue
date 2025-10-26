<script setup lang="ts">
interface Props {
  mobile?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  mobile: false,
})
</script>

<template>
  <div
    :class="[
      props.mobile
        ? 'flex items-center gap-3'
        : 'hidden flex-col items-center gap-3 md:flex',
    ]"
  >
    <!-- 10x -->
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      :drop-shadow-x="2"
      :drop-shadow-y="2"
      drop-shadow-color="lime"
    >
      <a
        href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
        target="_blank"
        class="flex h-8 w-8 items-center justify-center bg-black p-1"
      >
        <Icon
          name="svg:10x-pixelated"
          color="white"
          class="h-auto w-5"
          style="shape-rendering: crispEdges"
        />
      </a>
    </PixelRounded>
    <!-- github -->
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      :drop-shadow-x="2"
      :drop-shadow-y="2"
      drop-shadow-color="lime"
    >
      <a
        href="https://github.com/rublev"
        target="_blank"
        class="flex h-8 w-8 items-center justify-center bg-black p-1"
      >
        <Icon
          name="svg:github"
          color="white"
          class="h-auto w-5"
          style="shape-rendering: crispEdges"
        />
      </a>
    </PixelRounded>
    <!-- linkedin -->
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      :drop-shadow-x="2"
      :drop-shadow-y="2"
      drop-shadow-color="lime"
    >
      <a
        href="https://www.linkedin.com/in/marcelolszewski/"
        target="_blank"
        class="flex h-8 w-8 items-center justify-center bg-black p-1"
      >
        <Icon
          name="svg:linkedin"
          color="white"
          class="h-auto w-5"
          style="shape-rendering: crispEdges"
        />
      </a>
    </PixelRounded>
    <!-- email -->
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      :drop-shadow-x="2"
      :drop-shadow-y="2"
      drop-shadow-color="lime"
    >
      <a
        href="mailto:hi@olsz.me"
        class="flex h-8 w-8 items-center justify-center bg-black p-1"
      >
        <Icon
          name="svg:email"
          color="white"
          class="h-auto w-5"
          style="shape-rendering: crispEdges"
        />
      </a>
    </PixelRounded>
    <!-- cv -->
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      :drop-shadow-x="2"
      :drop-shadow-y="2"
      drop-shadow-color="lime"
    >
      <a
        href="/resume.pdf"
        target="_blank"
        class="
          flex h-8 w-8 items-center justify-center bg-black p-1 font-pressstart
          text-xs
        "
      >
        CV
      </a>
    </PixelRounded>
  </div>
</template>
