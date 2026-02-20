# SHOPPUS

A modern, responsive e-commerce website for consumer tech gadgets. Built with React, Vite, and React Router.

## Features

- **Browse by Category**: Phones, Laptops, Smartwatches, Monitors, Accessories
- **Product Search & Filtering**: Search bar, price range, brand, rating filters
- **Product Details**: Gallery, specifications, mock reviews
- **Shopping Cart**: Add/remove items, adjust quantities, persistent via localStorage
- **Checkout Flow**: Multi-step checkout (shipping, payment, confirmation)
- **AI Assistant Panel**: Placeholder for Copilot Studio / Power Virtual Agents embedding
- **Interactive UI polish**: navigation links highlight the current page, homepage features a scrolling color‑changing slogan, and the AI help button lives at the bottom‑left with updated copy

## Tech Stack

- React 18
- Vite 5
- React Router 6

## Getting Started

```bash
npm install
npm run dev
```

Open [http://localhost:5173](http://localhost:5173) in your browser.

### Local image support

To avoid broken or remote‑hosted pictures the project includes a helper that downloads every product's current `image` URL into `public/images` and then rewrites `src/data/products.js` so the app uses the local copy. The script will **only process products that don’t already reference a local file** (i.e. those that are blank, use the placeholder, or still point at unsplash). For missing pictures it now tries a chain of lookups:

1. Wikipedia thumbnail API
2. Bing Images scrape
3. DuckDuckGo JSON API
4. Google Images scrape
5. Pinterest search scrape

This order covers the most reliable sources first and widens the net so very few items are left without a photo. Run it with:

```bash
npm run fetch-images
```

After the script finishes you may need to restart or hard-reload the development
server to see the new images (Vite sometimes caches the module). Use:

```bash
npm run dev      # start / restart the dev server
# then refresh your browser or clear cache if you still see placeholders
```

The first ten base products are pre‑populated with official vendor photos; any others will default to `placeholder.png` unless you supply a proper URL. For true "official" pictures:

1. Edit `src/data/products.js` and set each product's `image` field to the exact URL of the product photo from the manufacturer's site (or change it manually to `/images/yourfile.jpg` after downloading yourself).
2. Rerun `npm run fetch-images` – this will pull the files into `public/images` and update the data file accordingly.

This keeps the storefront self‑contained and immune to upstream failures.

> **Note:** some vendors (e.g. B&H) block automated fetching. In those cases the
> script will leave the original remote URL in `products.js` instead of a local
> copy; the app will still display the image directly from the source.  If you
> prefer a local file you can manually download it to `public/images/<id>.*`.

### Generative AI placeholder images

If manually hunting down official photo URLs is too time-consuming, you can auto-generate
photorealistic images using OpenAI's image model.  A helper script is provided at
`scripts/generateAIImages.js` which:

1. Iterates over every product in `src/data/products.js`.
2. Calls the OpenAI Images API with a prompt like:
   "A high-quality photorealistic product photograph of a {brand} {name} on a white background." 
3. Saves the resulting PNG to `public/images/<id>.png` and rewrites the product's
   `image` field to reference the local file.

To use it, first make sure you have an API key:

```bash
export OPENAI_API_KEY=your_key_here    # or set in Windows env vars
# if you want to use the public OpenAI service, you do *not* need any other
# variables.  The script will call the normal api.openai.com endpoint.

# to target an Azure OpenAI / Foundry endpoint set the base URL.
# the script will normalize the URL, so you can supply either the root
# (e.g. https://picky-resource.services.ai.azure.com) or include the
# "/openai/" path.  You may also specify a different API version if
# needed by setting AZURE_API_VERSION (defaults to 2024-12-01):
export OPENAI_BASE_URL=https://picky-resource.services.ai.azure.com/
# optionally export AZURE_API_VERSION=2024-12-01

npm run generate-ai-images             # command added below
```

The script will take a few minutes for the whole catalog and incurs a few cents of
cost per image.  Once complete, the app will display AI-generated photos for every
product, making the storefront entirely self-contained without any external network
dependencies.

#### Troubleshooting Azure 404s
If you set `OPENAI_BASE_URL` to an Azure/Foundry endpoint and the script prints
`404 Resource Not Found` for every product, the most likely causes are:

1. The supplied base URL is not the correct OpenAI endpoint for the resource
   (e.g. you used the root Azure portal URL instead of the OpenAI host).
2. The resource has not been configured with an image model (`gpt-image-1`) or
   the image feature isn’t enabled on that instance.
3. Your API version is incompatible – you can override it with
   `AZURE_API_VERSION` (default `2024-12-01`).

The generated log will show the full request URL; verify that it looks like
`https://<your-host>/openai/images?api-version=…` and paste it into a browser or
curl for further investigation.  Removing `OPENAI_BASE_URL` will cause the
script to fall back to the public OpenAI service if you have a key that works there.


## Build

```bash
npm run build
npm run preview
```

## Troubleshooting: npm install fails on Windows

If you see `ENOENT`, `TAR_ENTRY_ERROR`, or "tarball seems to be corrupted" errors:

1. **Clean and retry** – Run `install-and-run.ps1` in PowerShell (optionally as Administrator).
2. **Shorter path** – Copy the project to `C:\shoppus` and run `npm install` from there (avoids Windows path length limits).
3. **Close other tools** – Close VS Code, other terminals, and any processes using the project folder.
4. **Antivirus** – Temporarily disable real-time protection and retry.
5. **Use pnpm instead** – Often works when npm fails on Windows:
   ```bash
   npm install -g pnpm
   pnpm install
   pnpm dev
   ```

## AI Assistant Integration

The AI assistant is a floating chat widget with a collapsible right-side panel. To embed your Copilot Studio or Power Virtual Agents bot:

1. Open `src/components/AIAssistant.jsx`
2. Locate the `#copilot-studio-container` div
3. Replace the placeholder content with your bot's iframe or web chat script

Example for Power Virtual Agents:
```html
<div id="copilot-studio-container">
  <!-- Your PVA web chat embed here -->
</div>
```

## Project Structure

```
src/
├── components/     # Reusable UI components
├── context/        # React context (cart state)
├── data/           # Mock product data
├── pages/          # Route components
├── styles/         # Global CSS
└── main.jsx
```
