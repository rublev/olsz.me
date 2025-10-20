<script setup lang="ts">
interface Props {
  /** Icon name for the left icon (e.g., 'svg:rocket') */
  icon: string
  /** First part of the job string (e.g., 'building startups') */
  title: string
  /** Company URL */
  companyUrl?: string
  /** Company title/domain (e.g., 'stratosphere.digital') */
  companyTitle?: string
  /** Technology tags */
  tags: string[]
  /** Optional GitHub repository URL */
  githubUrl?: string
  /** Optional suffix string (e.g., 'acq by <a>coinbase</a>') */
  suffix?: string
  /** Optional Product Hunt URL */
  productHuntUrl?: string
  /** Optional flame icon URL (for featured/special projects) */
  flameUrl?: string
}

defineProps<Props>()
</script>

<template>
  <div class="flex items-center">
    <PixelRounded
      :radius="4"
      :multiplier="2"
      :border-width="1"
      border-color="lime"
      drop-shadow
      drop-shadow-color="lime"
      :drop-shadow-x="2"
      :drop-shadow-y="2"
    >
      <div class="xerox flex items-center gap-2 bg-black p-2 text-matrix">
        <!-- Left Icon -->
        <Icon
          :name="icon"
          class="h-full w-6 flex-shrink-0"
          style="shape-rendering: crispEdges1"
          color="lime"
        />

        <!-- Content -->
        <div class="flex-1 text-[28px] leading-[0.75em] font-bold">
          <!-- Title and Company -->
          <div class="">
            {{ title }}
            <template v-if="companyUrl && companyTitle">
              <span class="">
                @
              </span>
              <a
                :href="companyUrl"
                target="_blank"
                class="hover:underline"
              >
                {{ companyTitle }}
              </a>
            </template>
            <template v-if="suffix">
              <span
                class="ml-2"
                v-html="suffix"
              />
            </template>
          </div>

          <!-- Tech Tags -->
          <div class="hidden font-monda text-sm leading-[0.7em]">
            {{ tags.join(" / ") }}
          </div>
        </div>

        <!-- GitHub Icon (inside box, far right) -->
        <a
          v-if="githubUrl"
          :href="githubUrl"
          target="_blank"
          class="
            flex-shrink-0 text-white transition-colors
            hover:text-purple-500
          "
        >
          <Icon
            name="svg:github"
            class="h-6 w-6 border-2 border-black bg-black"
            style="shape-rendering: crispEdges"
          />
        </a>
      </div>
    </PixelRounded>

    <!-- Product Hunt Icon (outside box) -->
    <a
      v-if="productHuntUrl"
      :href="productHuntUrl"
      target="_blank"
      class="
        flex-shrink-0 text-yellow-500 transition-colors
        hover:text-yellow-400
      "
    >
      <Icon
        name="svg:trophy"
        class="h-6 w-6"
        style="shape-rendering: crispEdges1"
      />
    </a>

    <!-- Flame Icon (outside box) -->
    <a
      v-if="flameUrl"
      :href="flameUrl"
      target="_blank"
      class="
        flex-shrink-0 text-red-500 transition-colors
        hover:text-red-400
      "
    >
      <Icon
        name="svg:flame"
        class="h-6 w-6"
        style="shape-rendering: crispEdges1"
      />
    </a>
  </div>
</template>
