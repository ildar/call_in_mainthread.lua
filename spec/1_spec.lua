local cim = require 'call_in_mainthread'

describe("This module", function()
  it("can execute a function",
    function()
      local status, info
      local tab = {}
      local function f()
        for i=1,3 do
          local status = cim.mainthread_call(table.insert, tab, i)
          assert.is_equal( true, status )
        end
      end
      local co = coroutine.create(f)
      repeat
        status, info = coroutine.resume(co)
        cim.mainthread_process()
      until not status
      assert.is_equal( "123", table.concat(tab) )
    end)
end)
  
