
# Network CIDR Block Notation


## CIDR stands for Classles Inter Domain Routing

An IP address identifies a **network** or sub-network (**subnet**).

CIDR allows for blocks of IP addresses to be allocated to ISPs (Internet Service Providers).
It also allows network designers to carve out address spaces with LANs or even VPCs (Virtual Private Clouds).

With CIDR IP addressing can be visualized as a tree.

## Internet (Public) Addressing

Public addressing is tightly controlled and the tree of public addresses (of class IPV4) is running out. The further down the tree you are - the less the number of addresses you have to play with.

Large ISPs control the lion's share of publicly routable addresses and they loan these out to their customers.

## Assignment of IP Address CIDR blocks.

<pre>
The assignment of CIDR blocks is handled by the Internet Assigned Numbers Authority (IANA). One of the duties of the IANA is to issue large blocks of IP addresses to regional Internet registries (RIRs). These blocks are used for large geographical areas, such as Europe, North America, Africa and Australia. It is then the duty of each RIR to create smaller, but still quite large, blocks of IP addresses to be assigned to local Internet registries (LIRs). Depending on the organization of regional and local registries, blocks may be subdivided further until they are assigned to end users. The size of blocks assigned to end users is dependent on how many individual addresses will be required by each user. Most end users receive their blocks from a single Internet service provider (ISP), but organizations that make use of multiple ISPs must obtain provider-independent blocks directly from an LIR or RIR.
</pre>

## The CIDR Notation Blocks

Use an IP Address suffix of 32 (mass 255.255.255.255) to denote a single host.

All other suffices identify a block of hosts. How many is determined with this formula.

     2^(32 - suffix)




IPv4 CIDR       Delta           Mask	        Hosts   Class
a.b.c.d/32      +0.0.0.0	255.255.255.255	1	1/256 C
a.b.c.d/31	+0.0.0.1	255.255.255.254	2	1/128 C
a.b.c.d/30	+0.0.0.3	255.255.255.252	4	1/64 C
a.b.c.d/29	+0.0.0.7	255.255.255.248	8	1/32 C
a.b.c.d/28	+0.0.0.15	255.255.255.240	16	1/16 C
a.b.c.d/27	+0.0.0.31	255.255.255.224	32	1/8 C
a.b.c.d/26	+0.0.0.63	255.255.255.192	64	1/4 C
a.b.c.d/25	+0.0.0.127	255.255.255.128	128	1/2 C
a.b.c.0/24	+0.0.0.255	255.255.255.000	256	1 C
a.b.c.0/23	+0.0.1.255	255.255.254.000	512	2 C
a.b.c.0/22	+0.0.3.255	255.255.252.000	1,024	4 C
a.b.c.0/21	+0.0.7.255	255.255.248.001	2,048	8 C
a.b.c.0/20	+0.0.15.255	255.255.240.000	4,096	16 C
a.b.c.0/19	+0.0.31.255	255.255.224.000	8,192	32 C
a.b.c.0/18	+0.0.63.255	255.255.192.000	16,384	64 C
a.b.c.0/17	+0.0.127.255	255.255.128.000	32,768	128 C
a.b.0.0/16	+0.0.255.255	255.255.000.000	65,536	256 C = 1 B
a.b.0.0/15	+0.1.255.255	255.254.000.000	131,072	2 B
a.b.0.0/14	+0.3.255.255	255.252.000.000	262,144	4 B
a.b.0.0/13	+0.7.255.255	255.248.000.000	524,288	8 B
a.b.0.0/12	+0.15.255.255	255.240.000.000	1,048,576	16 B
a.b.0.0/11	+0.31.255.255	255.224.000.000	2,097,152	32 B
a.b.0.0/10	+0.63.255.255	255.192.000.000	4,194,304	64 B
a.b.0.0/9	+0.127.255.255	255.128.000.000	8,388,608	128 B
a.0.0.0/8	+0.255.255.255	255.000.000.000	16,777,216	256 B = 1 A
a.0.0.0/7	+1.255.255.255	254.000.000.000	33,554,432	2 A
a.0.0.0/6	+3.255.255.255	252.000.000.000	67,108,864	4 A
a.0.0.0/5	+7.255.255.255	248.000.000.000	134,217,728	8 A
a.0.0.0/4	+15.255.255.255	240.000.000.000	268,435,456	16 A
a.0.0.0/3	+31.255.255.255	224.000.000.000	536,870,912	32 A
a.0.0.0/2	+63.255.255.255	192.000.000.000	1,073,741,824	64 A
a.0.0.0/1	+127.255.255.255	128.000.000.000	2,147,483,648	128 A
0.0.0.0/0	+255.255.255.255	000.000.000.000	4,294,967,296	256 A

