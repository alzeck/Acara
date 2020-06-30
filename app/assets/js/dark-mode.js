function updateColor() {
  if (document.body.hasAttribute('data-theme')) {
    document.body.removeAttribute('data-theme');
    localStorage.theme = 'light';
  }
  else {
      document.body.setAttribute('data-theme','dark');
      localStorage.theme = 'dark';
  }
}

// check correct theme to use 
if (localStorage.getItem('theme') === 'dark' && (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ) {
  // check system preferences 
  document.body.setAttribute('data-theme','dark');
}
