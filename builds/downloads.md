---
title: "Gearmulator Downloads"
layout: default
permalink: /builds/downloads
---

<label>Product: <select id="productFilter"><option value="">All</option></select></label>
<label>Format: <select id="formatFilter"><option value="">All</option></select></label>
<label>OS: <select id="osFilter"><option value="">All</option></select></label>
<label>Version: <select id="versionFilter"></select></label>

<ul id="assetList"></ul>

<style>
  #assetList { list-style-type: none; padding: 0; }
  #assetList li { margin: 0.3em 0; }
</style>

<script>
const REPO = 'dsp56300/gearmulator';
const VALID_FORMATS = new Set(['AU','CLAP','LV2','VST2','VST3']);

async function fetchVersionList() {
    // 1. Try local cached versions.json
    try {
        const localResp = await fetch('versions.json', { cache: "no-store" });
        if (localResp.ok) {
            const versions = await localResp.json();
            if (Array.isArray(versions) && versions.length > 0) {
                console.log("Using cached versions.json");
                return versions;
            }
        }
    } catch (e) { /* ignore */ }

    // 2. Fallback to GitHub API
    try {
        const resp = await fetch(`https://api.github.com/repos/${REPO}/releases?per_page=100`);
        if (resp.ok) {
            const releases = await resp.json();
            return releases.map(r => r.tag_name).filter(t => t && /^\d/.test(t));
        }
    } catch (e) { /* ignore */ }

    return [];
}

async function fetchRelease(version) {
    const localUrl = `${version}.json`;
    const githubUrl = `https://api.github.com/repos/${REPO}/releases/tags/${version}`;

    // 1. Try local cached JSON
    try {
        const localResp = await fetch(localUrl, { cache: "no-store" });
        if (localResp.ok) {
            console.log("Using cached release JSON:", localUrl);
            return localResp;
        }
    } catch (e) {
        // Network or CORS error – ignore and fallback
    }

    // 2. Fallback to GitHub API
    console.log("Falling back to GitHub API");
    const apiResp = await fetch(githubUrl);
    if (!apiResp.ok)
        throw new Error("Failed to fetch release data");

    return apiResp;
}

function parseAssets(data) {
    return data.assets.map(a => {
        const name = a.name;
        const parts = name.split('-');

        const product = parts[1] || '';
        const maybeFormat = parts[2] || '';
        const format = VALID_FORMATS.has(maybeFormat) ? maybeFormat : '';

        const osIndex = format === '' ? 3 : 4;
        let os = parts[osIndex] || '';
        os = os.replace(/\.[^/.]+$/, '');

        return { name, url: a.browser_download_url, product, format, os };
    });
}

function populateFilter(select, items, preValue) {
    // Remove all options except the first "All"
    while (select.options.length > 1) select.remove(1);

    [...items].sort().forEach(i => {
        const opt = document.createElement('option');
        opt.value = i; opt.textContent = i;
        if (i === preValue) opt.selected = true;
        select.appendChild(opt);
    });
}

let currentAssets = [];

function render() {
    const assetList = document.getElementById('assetList');
    assetList.innerHTML = '';
    const p = document.getElementById('productFilter').value;
    const f = document.getElementById('formatFilter').value;
    const o = document.getElementById('osFilter').value;

    currentAssets.forEach(a => {
        if ((p === '' || a.product === p) &&
            (f === '' || a.format === f) &&
            (o === '' || a.os === o)) {
            const li = document.createElement('li');
            const link = document.createElement('a');
            link.href = a.url;
            link.textContent = a.name;
            li.appendChild(link);
            assetList.appendChild(li);
        }
    });
}

async function loadVersion(version, preProduct, preFormat, preOS) {
    const assetList = document.getElementById('assetList');
    assetList.innerHTML = '<li>Loading...</li>';

    try {
        const resp = await fetchRelease(version);
        const data = await resp.json();
        currentAssets = parseAssets(data);

        const products = new Set();
        const formats = new Set();
        const oses = new Set();

        currentAssets.forEach(a => {
            if (a.product) products.add(a.product);
            if (a.format) formats.add(a.format);
            if (a.os) oses.add(a.os);
        });

        populateFilter(document.getElementById('productFilter'), products, preProduct);
        populateFilter(document.getElementById('formatFilter'), formats, preFormat);
        populateFilter(document.getElementById('osFilter'), oses, preOS);

        render();
    } catch (e) {
        assetList.innerHTML = `<li>Error loading version ${version}: ${e.message}</li>`;
    }
}

async function main() {
    const params = new URLSearchParams(window.location.search);
    const preVersion = params.get('version') || '';
    const preProduct = params.get('product') || '';
    const preFormat = (params.get('format') || '') === 'All' ? '' : (params.get('format') || '');
    const preOS = (params.get('os') || '') === 'All' ? '' : (params.get('os') || '');

    const versionFilter = document.getElementById('versionFilter');
    const productFilter = document.getElementById('productFilter');
    const formatFilter = document.getElementById('formatFilter');
    const osFilter = document.getElementById('osFilter');

    // Populate version selector
    const versions = await fetchVersionList();

    versions.forEach(v => {
        const opt = document.createElement('option');
        opt.value = v; opt.textContent = v;
        if (v === preVersion) opt.selected = true;
        versionFilter.appendChild(opt);
    });

    // If preVersion was specified but not in the list, select the first available
    if (preVersion && !versions.includes(preVersion)) {
        const opt = document.createElement('option');
        opt.value = preVersion; opt.textContent = preVersion;
        opt.selected = true;
        versionFilter.insertBefore(opt, versionFilter.firstChild);
    }

    // If no version specified, default to the first (latest)
    if (!preVersion && versions.length > 0) {
        versionFilter.value = versions[0];
    }

    const selectedVersion = versionFilter.value;
    if (!selectedVersion) {
        document.getElementById('assetList').innerHTML = '<li>No versions available</li>';
        return;
    }

    // Load initial version
    await loadVersion(selectedVersion, preProduct, preFormat, preOS);

    // Version change reloads everything
    versionFilter.addEventListener('change', () => {
        loadVersion(versionFilter.value, '', '', '');
    });

    productFilter.addEventListener('change', render);
    formatFilter.addEventListener('change', render);
    osFilter.addEventListener('change', render);
}

main();
</script>
