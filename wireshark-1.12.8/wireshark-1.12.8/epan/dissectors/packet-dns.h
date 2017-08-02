/* packet-dns.h
 * Definitions for packet disassembly structures and routines used both by
 * DNS and NBNS.
 *
 * Wireshark - Network traffic analyzer
 * By Gerald Combs <gerald@wireshark.org>
 * Copyright 1998 Gerald Combs
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */


#ifndef __PACKET_DNS_H__
#define __PACKET_DNS_H__

const char *dns_class_name(int dns_class);

int expand_dns_name(tvbuff_t *, int, int, int, const guchar **);
/* Just like expand_dns_name, but pretty-prints empty names. */
int get_dns_name(tvbuff_t *, int, int, int, const guchar **);

#define MAXDNAME        1025            /* maximum domain name length */

#endif /* packet-dns.h */
