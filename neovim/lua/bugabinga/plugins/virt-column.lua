return {
  {
    'lukas-reineke/virt-column.nvim',
    event = { 'BufReadPost', 'BufNew' },
    opts = {
      char = '│',
    },
  },
}
