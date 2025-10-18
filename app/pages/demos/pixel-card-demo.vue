<template>
  <div class="container mx-auto space-y-8 p-8">
    <h1 class="mb-8 text-4xl font-bold text-white">
      PixelCard Component Demo
    </h1>

    <div
      class="
        grid grid-cols-1 gap-8
        md:grid-cols-2
        lg:grid-cols-3
      "
    >
      <!-- Basic usage -->
      <PixelCard bg="white" padding="1.5rem">
        <h2 class="mb-2 text-xl font-bold">
          Basic Card
        </h2>
        <p class="text-gray-600">
          Default: 1 step of 4px. Simple single indent.
        </p>
      </PixelCard>

      <!-- 3 steps -->
      <PixelCard
        :step="4"
        :steps="3"
        bg="white"
        padding="1.5rem"
      >
        <h2 class="mb-2 text-xl font-bold">
          3 Steps
        </h2>
        <p class="text-gray-600">
          3 steps of 4px each = staircase effect.
        </p>
      </PixelCard>

      <!-- 5 steps -->
      <PixelCard
        :step="4"
        :steps="5"
        bg="white"
        padding="1.5rem"
      >
        <h2 class="mb-2 text-xl font-bold">
          5 Steps
        </h2>
        <p class="text-gray-600">
          5 steps of 4px each = smoother curve.
        </p>
      </PixelCard>

      <!-- Large steps, few count -->
      <PixelCard
        :step="8"
        :steps="2"
        bg="black"
        padding="1.5rem"
        border-color="lime"
        :border-width="2"
      >
        <h2 class="mb-2 text-xl font-bold text-white">
          Large Steps, 2 Count
        </h2>
        <p class="text-lime-400">
          2 steps × 8px = chunky retro look.
        </p>
      </PixelCard>

      <!-- Small steps, many count -->
      <PixelCard
        :step="2"
        :steps="8"
        bg="purple"
        padding="1.5rem"
      >
        <h2 class="mb-2 text-xl font-bold text-white">
          Small Steps, 8 Count
        </h2>
        <p class="text-purple-200">
          8 steps × 2px = smooth rounded look.
        </p>
      </PixelCard>

      <!-- Single large step -->
      <PixelCard
        :step="12"
        :steps="1"
        bg="cyan"
        padding="1.5rem"
      >
        <h2 class="mb-2 text-xl font-bold text-black">
          Single Large Step
        </h2>
        <p class="text-black">
          1 step of 12px = cut corner effect.
        </p>
      </PixelCard>

      <!-- Complex content -->
      <PixelCard
        :step="6"
        :steps="4"
        bg="linear-gradient(135deg, #667eea 0%, #764ba2 100%)"
        padding="2rem"
        border-color="white"
        :border-width="3"
      >
        <h2 class="mb-3 text-2xl font-bold text-white">
          Complex Content
        </h2>
        <ul class="mb-3 list-disc space-y-1 pl-5 text-white">
          <li>Gradient background</li>
          <li>White border</li>
          <li>4 steps × 6px</li>
        </ul>
        <button class="rounded bg-white px-4 py-2 font-bold text-blue-600">
          Click Me
        </button>
      </PixelCard>

      <!-- Transparent with border only -->
      <PixelCard
        :step="5"
        :steps="3"
        bg="transparent"
        padding="1.5rem"
        border-color="yellow"
        :border-width="2"
      >
        <h2 class="mb-2 text-xl font-bold text-white">
          Border Only
        </h2>
        <p class="text-gray-300">
          3 steps × 5px, transparent background.
        </p>
      </PixelCard>
    </div>

    <!-- Usage example -->
    <div class="mt-12">
      <h2 class="mb-4 text-2xl font-bold text-white">
        Usage
      </h2>
      <PixelCard
        bg="#1e1e1e"
        padding="2rem"
        border-color="lime"
        :border-width="1"
      >
        <pre class="overflow-x-auto text-sm text-lime-400"><code>&lt;PixelCard
  :step="4"
  :steps="3"
  bg="white"
  padding="1.5rem"
  border-color="lime"
  :border-width="2"
&gt;
  &lt;h2&gt;Your Content&lt;/h2&gt;
  &lt;p&gt;Anything you want!&lt;/p&gt;
&lt;/PixelCard&gt;</code></pre>
      </PixelCard>
    </div>

    <!-- Props documentation -->
    <div class="mt-8">
      <h2 class="mb-4 text-2xl font-bold text-white">
        Props
      </h2>
      <PixelCard bg="white" padding="2rem">
        <table class="w-full">
          <thead>
            <tr class="border-b-2 border-gray-300">
              <th class="pb-2 text-left">
                Prop
              </th>
              <th class="pb-2 text-left">
                Type
              </th>
              <th class="pb-2 text-left">
                Default
              </th>
              <th class="pb-2 text-left">
                Description
              </th>
            </tr>
          </thead>
          <tbody class="text-sm">
            <tr class="border-b border-gray-200">
              <td class="py-2 font-mono text-purple-600">
                step
              </td>
              <td class="py-2">
                Number
              </td>
              <td class="py-2 font-mono">
                4
              </td>
              <td class="py-2">
                Size of each pixel step in pixels
              </td>
            </tr>
            <tr class="border-b border-gray-200">
              <td class="py-2 font-mono text-purple-600">
                steps
              </td>
              <td class="py-2">
                Number
              </td>
              <td class="py-2 font-mono">
                1
              </td>
              <td class="py-2">
                Number of steps in each corner (1 = single indent, 3+ =
                staircase)
              </td>
            </tr>
            <tr class="border-b border-gray-200">
              <td class="py-2 font-mono text-purple-600">
                padding
              </td>
              <td class="py-2">
                String
              </td>
              <td class="py-2 font-mono">
                '1rem'
              </td>
              <td class="py-2">
                Internal padding
              </td>
            </tr>
            <tr class="border-b border-gray-200">
              <td class="py-2 font-mono text-purple-600">
                bg
              </td>
              <td class="py-2">
                String
              </td>
              <td class="py-2 font-mono">
                'transparent'
              </td>
              <td class="py-2">
                Background color or gradient
              </td>
            </tr>
            <tr class="border-b border-gray-200">
              <td class="py-2 font-mono text-purple-600">
                borderColor
              </td>
              <td class="py-2">
                String
              </td>
              <td class="py-2 font-mono">
                'currentColor'
              </td>
              <td class="py-2">
                Border color
              </td>
            </tr>
            <tr>
              <td class="py-2 font-mono text-purple-600">
                borderWidth
              </td>
              <td class="py-2">
                Number
              </td>
              <td class="py-2 font-mono">
                0
              </td>
              <td class="py-2">
                Border width in pixels
              </td>
            </tr>
          </tbody>
        </table>
      </PixelCard>
    </div>
  </div>
</template>
