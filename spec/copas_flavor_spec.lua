local cim = require 'call_in_mainthread'
local copas = require 'copas'

describe("This module used in #copas loop", function()
  it("can execute a function",
    function()
      local costatus = true
      local tab = {}
      local function f()
        for i=1,3 do
          costatus = costatus and cim.mainthread_call(table.insert, tab, i)
        end
      end
      copas.addthread(f)
      -- copas.loop() midified
      copas.running = true
      while not copas.finished() do
        copas.step()
        cim.mainthread_process()
      end
      copas.running = false
      
      assert.is_equal( true, costatus )
      assert.is_equal( "123", table.concat(tab) )
    end)

  it("can deal with errors in functions",
    function()
      local status, info, costatus, res
      local function f()
        costatus, res = cim.mainthread_call(error, "error msg")
      end
      copas.addthread(f)
      -- copas.loop() midified
      copas.running = true
      while not copas.finished() do
        copas.step()
        cim.mainthread_process()
      end
      copas.running = false
      
      assert.is_equal( false, costatus )
      assert.is_equal( "error msg", res )
    end)

end)
  
