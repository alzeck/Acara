function updateColor() {
  if (document.body.hasAttribute('data-theme')) {
    document.body.removeAttribute('data-theme');
    localStorage.removeItem('darkTheme')
  }
  else {
      document.body.setAttribute('data-theme','dark');
      localStorage.darkTheme = true;
  }
}

// check correct theme to use 
if (localStorage.getItem('darkTheme') && (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) ) {
  // check system preferences 
  document.body.setAttribute('data-theme','dark');
}
