<script setup lang="ts">
import GLYPHS from '@/assets/glyphs.json'

interface Job {
  icon: string
  title: string
  companyUrl?: string
  companyTitle?: string
  tags: string[]
  githubUrl?: string
  suffix?: string
  productHuntUrl?: string
  flameUrl?: string
}

const JOBS: {
  current: Job[]
  past: Job[]
  other: Job[]
} = {
  current: [
    {
      icon: 'svg:ai',
      title: 'no-code ai browser testing platform',
      companyUrl: 'https://browsertest.ai',
      companyTitle: 'browsertest.ai',
      tags: ['vue', 'typescript', 'node'],
    },
    {
      icon: 'svg:mugen',
      title: 'fastest offline-first infinite canvas',
      companyUrl: 'https://mugen.cafe',
      companyTitle: 'mugen.cafe ',
      tags: ['c++', 'wasm', 'crdts', 'pixijs', 'webgpu', 'typescript'],
      githubUrl: 'https://github.com/rublev',
    },
    {
      icon: 'svg:remote-yes',
      title: 'minimalistic job hunting portal',
      companyUrl: 'https://remote-yes.com',
      companyTitle: 'remote-yes.com',
      tags: ['vue', 'typescript', 'gcp'],
    },
  ],
  past: [
    {
      icon: 'svg:house',
      title: 'real-estate ai chatbot',
      companyUrl: 'https://valery.ca',
      companyTitle: 'valery.ca',
      tags: ['vue', 'typescript', 'firebase'],
    },
    {
      icon: 'svg:rocket',
      title: 'building startups',
      companyUrl: 'https://stratosphere.digital',
      companyTitle: 'stratosphere.digital',
      tags: ['vue', 'react', 'typescript'],
    },
    {
      icon: 'svg:wallet',
      title: 'tech employee wealth manager',
      companyUrl: 'https://withcompound.com',
      companyTitle: 'withcompound.com',
      tags: ['react', 'typescript'],
    },
    {
      icon: 'svg:scales',
      title: 'stablecoin exchange',
      companyUrl: 'https://paytrie.com',
      companyTitle: 'paytrie.com',
      tags: ['react', 'typescript'],
      suffix:
        ' <a href="https://consensys.io" target="_blank" class="hover:underline">@ consensys.io↗</a>',
    },
    {
      icon: 'svg:code',
      title: 'programming  questions',
      companyUrl: 'https://paytrie.com',
      companyTitle: 'dailycodingproblem.com',
      tags: ['react', 'typescript'],
      productHuntUrl: 'https://google.com',
    },
    {
      icon: 'svg:card',
      title: 'a delightful crypto wallet',
      companyUrl: 'https://brd.com',
      companyTitle: 'brd.com',
      tags: ['react', 'go'],
      githubUrl: 'https://github.com/rublev',
      flameUrl: 'string',
    },
    {
      icon: 'svg:bank',
      title: 'retail & commercial mobile banking apps',
      companyUrl: 'https://rbcroyalbank.com',
      companyTitle: 'rbcroyalbank.com',
      tags: ['phonegap', 'javascript'],
    },
  ],
  other: [
    {
      icon: 'svg:eye',
      title: 'openxr recenter override',
      tags: ['c++', 'python'],
      githubUrl: 'https://github.com/rublev',
    },
    {
      icon: 'svg:folder-open',
      title: 'old portfolio site',
      tags: ['vue', 'typescript'],
    },
    {
      icon: 'svg:retro-camera',
      title: 'piklink',
      tags: ['web3', 'decentralized', 'instagram', 'clone', 'blockstack'],
    },
    {
      icon: 'svg:retro-camera',
      title: 'supaglobal',
      tags: ['web3', 'decentralized', 'instagram', 'clone', 'blockstack'],
    },
    {
      icon: 'svg:retro-camera',
      title: 'monumental crane',
      tags: ['web3', 'decentralized', 'instagram', 'clone', 'blockstack'],
    },
  ],
}
</script>

<template>
  <div class="flex w-auto gap-3">
    <!-- SIDEBAR -->
    <div class="flex flex-col items-center gap-3">
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
    </div>
    <!-- CONTENT -->
    <div class="flex w-auto flex-col gap-3">
      <!-- top header section -->
      <div
        class="
          flex items-stretch gap-3 bg-transparent font-neuebit text-4xl
          font-bold
        "
      >
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
        >
          <div class="bg-matrix">
            <img
              src="~/assets/images/me-pixelized@4x.png"
              class="
                selection-black -mb-1 h-[128px] w-auto mix-blend-hard-light
              "
              style="image-rendering: optimizequality"
            >
          </div>
        </PixelRounded>
        <div
          class="
            selection-black flex w-0 flex-1 flex-col justify-center font-gohu
            text-sm
          "
        >
          <p class="text-xl">
            Hey, I'm Marcel {{ GLYPHS.katakana.shi }}
          </p>
          <p style="overflow-wrap: anywhere" class="leading-snug font-light">
            Full Stack developer/designer working mostly with early to mid-stage
            startups. Currently working on a few fun projects and looking for my
            next exciting role!
          </p>
          <p class="font-bold text-matrix">
            Reach out!
          </p>
        </div>
      </div>

      <div class="flex w-full flex-col gap-3">
        <!-- CURRENTLY -->
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
          drop-shadow
          :drop-shadow-x="5"
          :drop-shadow-y="5"
          drop-shadow-color="black"
          full
        >
          <section class="flex flex-col gap-0.5 p-0">
            <div class="flex items-center gap-2 pl-1">
              <div
                class="
                  selection-black font-4b text-sm leading-none tracking-wider
                  text-black
                "
              >
                currently:
              </div>
            </div>
            <ProjectRow2
              v-for="(job, index) in JOBS.current"
              :key="`current-${index}`"
              :icon="job.icon"
              :title="job.title"
              :company-url="job.companyUrl"
              :company-title="job.companyTitle"
              :tags="job.tags"
              :github-url="job.githubUrl"
              :suffix="job.suffix"
              :product-hunt-url="job.productHuntUrl"
              :flame-url="job.flameUrl"
            />
          </section>
        </PixelRounded>

        <!-- THINGS I'VE WORKED ON -->
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
          drop-shadow
          :drop-shadow-x="5"
          :drop-shadow-y="5"
          drop-shadow-color="black"
          full
        >
          <section class="flex flex-col gap-0.5 p-0">
            <div class="flex items-center gap-2 pl-1">
              <div
                class="
                  selection-black font-4b text-sm leading-none tracking-wider
                  text-black
                "
              >
                worked on
              </div>
            </div>
            <ProjectRow2
              v-for="(job, index) in JOBS.past"
              :key="`past-${index}`"
              :icon="job.icon"
              :title="job.title"
              :company-url="job.companyUrl"
              :company-title="job.companyTitle"
              :tags="job.tags"
              :github-url="job.githubUrl"
              :suffix="job.suffix"
              :product-hunt-url="job.productHuntUrl"
              :flame-url="job.flameUrl"
            />
          </section>
        </PixelRounded>

        <!-- OTHER PROJECTS -->
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
          drop-shadow
          :drop-shadow-x="5"
          :drop-shadow-y="5"
          drop-shadow-color="black"
          full
        >
          <section class="flex flex-col gap-0.5 p-0">
            <div class="flex items-center gap-2 pl-1">
              <div
                class="
                  selection-black font-4b text-sm leading-none tracking-wider
                  text-black
                "
              >
                other projects
              </div>
            </div>
            <ProjectRow2
              v-for="(job, index) in JOBS.other"
              :key="`other-${index}`"
              :icon="job.icon"
              :title="job.title"
              :company-url="job.companyUrl"
              :company-title="job.companyTitle"
              :tags="job.tags"
              :github-url="job.githubUrl"
              :suffix="job.suffix"
              :product-hunt-url="job.productHuntUrl"
              :flame-url="job.flameUrl"
            />
          </section>
        </PixelRounded>
      </div>
    </div>
  </div>
</template>
