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
      companyUrl: 'https://mugen.town',
      companyTitle: 'mugen.town ムゲン',
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
        '<a href="https://consensys.io" target="_blank" class="hover:underline">@ consensys.io</a>',
    },
    {
      icon: 'svg:card',
      title: 'a delightful crypto wallet',
      companyUrl: 'https://brd.com',
      companyTitle: 'brd.com',
      tags: ['react', 'go'],
      githubUrl: 'https://github.com/rublev',
      suffix:
        'acq by <a href="https://www.coindesk.com/business/2021/11/24/coinbase-acquires-crypto-wallet-firm-brd-for-undisclosed-amount" target="_blank" class="hover:underline">coinbase↗</a>',
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
  ],
}
</script>

<template>
  <div class="flex w-full max-w-2xl gap-5">
    <!-- SIDEBAR -->
    <div class="flex flex-col gap-4">
      <!-- 10x -->
      <a
        href="https://app.10xmanagement.com/clients/marcel-olszewski-16302/profile"
        target="_blank"
      >
        <Icon
          name="svg:10x-pixelated"
          class="h-auto w-6"
          color="white"
          style="shape-rendering: crispEdges1"
        />
      </a>
      <!-- github -->
      <a
        href="https://github.com/rublev"
        target="_blank"
      >
        <Icon
          name="svg:github"
          class="h-auto w-6"
          color="white"
          style="shape-rendering: crispEdges1"
        />
      </a>
      <!-- linkedin -->
      <a
        href="https://www.linkedin.com/in/marcelolszewski/"
        target="_blank"
      >
        <Icon
          name="svg:linkedin"
          class="h-auto w-6"
          color="white"
          style="shape-rendering: crispEdges1"
        />
      </a>
      <!-- email -->
      <a href="mailto:hi@olsz.me">
        <Icon
          name="svg:email"
          class="h-auto w-6"
          color="white"
          style="shape-rendering: crispEdges1"
        />
      </a>
    </div>
    <!-- CONTENT -->
    <div class="flex-1 space-y-4">
      <!-- top header section -->
      <div class="flex flex-col font-mondwest">
        <h1 class="text-5xl font-bold">
          Hey, I'm Marcel {{ GLYPHS.katakana.shi }}
        </h1>
        <p class="text-2xl font-normal">
          Frontend & design oriented full-stack developer
        </p>
      </div>

      <!-- CURRENTLY -->
      <section class="flex flex-col gap-2">
        <h2
          class="
            self-start bg-black font-pressstart text-xl leading-none font-bold
            text-matrix text-shadow-2xs
          "
        >
          >currently
        </h2>
        <ProjectRow
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

      <!-- THINGS I'VE WORKED ON -->
      <section class="flex flex-col gap-2">
        <h2
          class="
            xerox self-start bg-black px-2 font-pressstart text-xl font-bold
            text-matrix text-shadow-2xs
          "
        >
          >worked on
        </h2>
        <ProjectRow
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

      <!-- OTHER PROJECTS -->
      <section class="space-y-3">
        <h2
          class="
            inline-block bg-matrix pt-0.75 pr-0.75 pl-0.75 font-pressstart
            text-xl leading-none font-bold text-black
          "
        >
          >other projects
        </h2>
        <div class="space-y-3">
          <ProjectRow
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
        </div>
      </section>
    </div>
  </div>
</template>
