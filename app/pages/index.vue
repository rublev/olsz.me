<script setup lang="ts">
import GLYPHS from '@/assets/glyphs.json'
</script>

<template>
  <div class="flex max-w-2xl" style="border: 2px solid red">
    <!-- SIDEBAR -->
    <div class="flex flex-col gap-4" style="border: 2px solid red">
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
      <a href="https://github.com/rublev" target="_blank">
        <Icon
          name="svg:github"
          class="h-auto w-6"
          color="white"
          style="shape-rendering: crispEdges1"
        />
      </a>
      <!-- linkedin -->
      <a href="https://www.linkedin.com/in/marcelolszewski/" target="_blank">
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
    <div class="flex-1 space-y-4" style="border: 2px solid yellow">
      <!-- top header section -->
      <div class="flex flex-col gap-2.5">
        <h1 id="fag" class="font-mondwest text-5xl font-bold">
          Hey, I'm Marcel {{ GLYPHS.katakana.shi }}
        </h1>
        <p class="font-mondwest text-2xl font-normal">
          Frontend & design oriented full-stack developer
        </p>
      </div>
      <!-- JOBS -->
      <ul
        class="
          mb-6 list-disc space-y-2 pl-6 font-['PP_NeueBit'] text-4xl leading-6
          tracking-wide
        "
      >
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          ROLE
          <a
            href="https://dailycodingproblem.com"
            class="relative transition-all duration-200"
            title="Daily Coding Problem"
          >
            LINK
          </a>
          <a
            href="https://techcrunch.com/2018/03/13/y-combinator-alum-daily-coding-problem-acquired-by-alpine-data-labs/"
            class=""
          >
            (acq)</a>
          <span
            class="
              text-xs text-gray-600
              dark:text-gray-600
            "
          >
            /
          </span>
          <a
            href="https://www.producthunt.com/products/daily-coding-problem/launches/daily-coding-problem"
            target="_blank"
            class=""
          >
            #2 ph
          </a>
        </li>
        <li class="before:mr-1 before:-ml-5 before:content-['-']">
          ROLE
          <a
            href="https://apps.apple.com/us/app/brd-bitcoin-wallet/id885251393"
            class="relative transition-all duration-200"
            title="Breadwallet"
          >
            LINK
          </a>
          <a
            href="https://www.coindesk.com/business/2021/11/24/coinbase-acquires-crypto-wallet-firm-brd-for-undisclosed-amount"
            class=""
          >
            (acq, Coinbase)
          </a>
        </li>
      </ul>
    </div>
  </div>
</template>
