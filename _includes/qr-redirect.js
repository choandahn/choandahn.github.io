// 명함 QR 이동. 들어온 쿼리(?ph_internal=1 등)를 목적지에 붙이되, 목적지에 이미 있는 키는 덮어쓰지 않는다.
function qrGo(dest) {
  var h = dest.indexOf('#'), base = h < 0 ? dest : dest.slice(0, h), hash = h < 0 ? '' : dest.slice(h);
  var q = base.indexOf('?'), has = {}, add = [];
  function key(pair) {
    var k = pair.split('=')[0].replace(/\+/g, ' ');
    try { return decodeURIComponent(k); } catch (e) { return k; }
  }
  if (q >= 0) base.slice(q + 1).split('&').forEach(function (p) { if (p) has[key(p)] = true; });
  location.search.slice(1).split('&').forEach(function (p) { if (p && !has[key(p)]) add.push(p); });
  if (add.length) dest = base + (q < 0 ? '?' : /[?&]$/.test(base) ? '' : '&') + add.join('&') + hash;
  location.replace(dest);
}
