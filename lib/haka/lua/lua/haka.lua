-- This Source Code Form is subject to the terms of the Mozilla Public
-- License, v. 2.0. If a copy of the MPL was not distributed with this
-- file, You can obtain one at http://mozilla.org/MPL/2.0/.

#include <haka/config.h>

#ifdef HAKA_FFI
local ffi = require('ffi')
local ffibinding = require('ffibinding')
ffi.cdef[[
	struct time {
	};

	bool time_tostring(const struct time *t, char *buffer, size_t len);
	double time_sec(const struct time *t);
]]

local prop = {
	seconds = { get = ffi.C.time_sec },
}

local meth = {
}

local tmp_str = ffi.new[[
	char[27] /* \see TIME_BUFSIZE */
]]

local mt = {
	__tostring = function (self)
		if not ffi.C.time_tostring(self, tmp_str, 27) then
			return nil
		end

		return ffi.string(tmp_str)
	end,
}

ffibinding.create_type("struct time", prop, meth, mt)
#endif