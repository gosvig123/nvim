return {
  {
    "echasnovski/mini.starter",
    version = false,
    config = function()
      local starter = require("mini.starter")

      -- Get lines written today using Git (requires Git installed)
      local function get_lines_written()
        local handle = io.popen(
          [[git log --since="midnight" --author=$(git config user.email) --pretty=tformat: --numstat | awk '{ add += $1; subs += $2 } END { if (add + subs > 0) printf " (+%d/-%d)", add, subs; else print "" }']]
        )
        local result = handle:read("*a")
        handle:close()
        return result ~= "" and result or "No changes yet!"
      end

      starter.setup({
        header = [[
               /\                    /\                
              /  \                  /##\               
             /    \                /####\              
            /      \              /######\             
           /        \   /\       /########\            
          /  /\      \ /##\     /##########\           
         /  /##\    / \####\   /############\          
        /  /####\  /   \####\_/##############\         
       /__/######\/     \#####################\_       
      /################\########################\_     
     /##################\##########################\   
    /####################\############################\ 
   /  __    __    __    __\    __    __    __    __    \
  /  /  \  /  \  /  \  /  \  /  \  /  \  /  \  /  \  _ \
 /__/____\/____\/____\/____\/____\/____\/____\/____\/___\

   |                                                        |
   |    "Programming is not a job. It's a passport to       |
   |     create the future. Feel lucky, stay curious."      |
   |                                                        |
   |--------------------------------------------------------|
        ]],
        items = {
          starter.sections.builtin_actions(),
          starter.sections.recent_files(10, true),
        },
        footer = function()
          local stats = get_lines_written()
          local quote = "🚀 Today's Code: " .. stats .. " | 📅 " .. os.date("%A, %B %d")
          return quote .. '\n"What we build changes who we are." - Jaron Lanier'
        end,
        content_hierarchy = "centered",
      })
    end,
  },
}
