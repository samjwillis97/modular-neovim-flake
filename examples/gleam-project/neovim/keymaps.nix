# Gleam project-specific keymaps
#
# Custom keybindings for Gleam development tasks

{
  keymaps = [
    # Run Gleam tests
    {
      mode = "n";
      key = "<leader>gt";
      action = "<cmd>!gleam test<CR>";
      options = {
        desc = "Run Gleam tests";
        silent = false;
      };
    }

    # Build Gleam project
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>!gleam build<CR>";
      options = {
        desc = "Build Gleam project";
        silent = false;
      };
    }

    # Run Gleam project
    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>!gleam run<CR>";
      options = {
        desc = "Run Gleam project";
        silent = false;
      };
    }

    # Format current Gleam file
    {
      mode = "n";
      key = "<leader>gf";
      action = "<cmd>!gleam format %<CR>";
      options = {
        desc = "Format current Gleam file";
        silent = false;
      };
    }

    # Run Gleam check (type checking)
    {
      mode = "n";
      key = "<leader>gc";
      action = "<cmd>!gleam check<CR>";
      options = {
        desc = "Run Gleam type check";
        silent = false;
      };
    }
  ];
}
