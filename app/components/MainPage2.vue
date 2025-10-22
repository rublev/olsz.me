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

function scrollDown() {
  window.scrollBy({
    top: window.innerHeight,
    behavior: 'smooth',
  })
}
</script>

<template>
  <div
    class="
      flex w-auto flex-col gap-3
      md:flex-row md:py-4
    "
  >
    <!-- MOBILE WHOLE PAGER -->
    <div
      class="
        flex min-h-svh flex-col items-start justify-end gap-5 p-4 pb-24
        md:hidden
      "
    >
      <!-- top header section -->
      <div
        class="
          flex items-center gap-6 bg-transparent font-neuebit text-4xl font-bold
        "
      >
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
          drop-shadow
          :drop-shadow-x="4"
          :drop-shadow-y="4"
          drop-shadow-color="lime"
        >
          <div
            class="
              flex h-[64px] w-[64px] items-center justify-center overflow-hidden
              bg-matrix
            "
            style="border: 2px solid black"
          >
            <NuxtImg
              src="/assets/images/me.png"
              width="64"
              height="64"
              densities="1x 2x"
              class="
                selection-black h-[64px] w-auto scale-200 mix-blend-hard-light
              "
              style="image-rendering: optimizequality"
              preload
            />
          </div>
        </PixelRounded>
        <div
          class="
            selection-black flex flex-1 flex-col justify-center gap-3 font-gohu
            text-sm
          "
        >
          <p
            class="font-pressstart text-base lowercase"
            style="
              text-shadow:
                0px 0px 1px black,
                1px 1px 1px black,
                2px 2px 1px black;
            "
          >
            hello,<br>
            I'm Marcel {{ GLYPHS.katakana.shi }}
          </p>
        </div>
      </div>
      <p
        class="
          font-gohu text-sm leading-snug font-light tracking-tight lowercase
        "
        style="
          text-shadow:
            -1px -1px 1px black,
            0px 0px 1px black,
            1px 1px 1px black;
        "
      >
        Full Stack developer/designer working mostly with early to mid-stage
        startups. Currently working on a few fun projects and looking for my
        next exciting role!
      </p>
      <!-- ALTERNATIVE -->
      <p
        class="hidden font-neuebit text-2xl leading-none font-bold"
        style="
          text-shadow:
            0px 0px 1px black,
            1px 1px 1px black,
            2px 2px 1px black;
        "
      >
        Full Stack developer&designer working mostly with early to mid-stage
        startups. <br>Working on a few fun projects and looking for my next
        exciting role!
      </p>
      <PixelRounded
        :radius="6"
        :multiplier="2"
        :border-width="1"
        border-color="lime"
        drop-shadow
        :drop-shadow-x="5"
        :drop-shadow-y="5"
        drop-shadow-color="#000000"
        class="cursor-pointer self-end"
        @click="scrollDown"
      >
        <div class="flex items-center px-2 pb-0.5 pl-3 text-black">
          <p class="mr-1 font-pressstart text-sm">
            more
          </p>
          <Icon
            name="svg:chevron-down"
            class="mt-0.25 h-4 w-auto"
            style="shape-rendering: crispEdges"
          />
        </div>
      </PixelRounded>
    </div>
    <!-- SIDEBAR -->
    <Sidebar />
    <!-- CONTENT -->
    <div class="flex w-auto flex-col gap-3 p-4 pt-0">
      <!-- top header section -->
      <div
        class="
          hidden items-stretch gap-3 bg-transparent font-neuebit text-4xl
          font-bold
          md:flex
        "
      >
        <PixelRounded
          :radius="8"
          :multiplier="2"
          :border-width="1"
          border-color="lime"
        >
          <div class="bg-matrix">
            <NuxtImg
              src="/assets/images/me.png"
              width="128"
              height="128"
              densities="1x 2x"
              class="
                selection-black -mb-1 h-[128px] w-auto bg-black
                mix-blend-hard-light
              "
              style="image-rendering: optimizequality"
              preload
            />
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
          <p
            style="overflow-wrap: anywhere"
            class="leading-snug font-light"
          >
            Full Stack developer/designer working mostly with early to mid-stage
            startups. Currently working on a few fun projects and looking for my
            next exciting role!
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
                  selection-black pt-0.5 pl-1 font-4b text-sm leading-none
                  tracking-tighter text-black
                  md:font-normal md:tracking-wider
                "
              >
                currently
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
                  selection-black pt-0.5 pl-1 font-4b text-sm leading-none
                  tracking-tighter text-black
                  md:font-normal md:tracking-wider
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
                  selection-black pt-0.5 pl-1 font-4b text-sm leading-none
                  tracking-tighter text-black
                  md:font-normal md:tracking-wider
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
