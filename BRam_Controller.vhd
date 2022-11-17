-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity BRam_Controller is
 Port (aclk : in std_logic;
 tvalid : in std_logic;
 tdata : in std_logic_vector(31 downto 0);
 
 clka : out STD_LOGIC;
 rsta : out STD_LOGIC;
 ena : out STD_LOGIC;
 wea : out STD_LOGIC_VECTOR ( 3 downto 0 );
 addra : out STD_LOGIC_VECTOR ( 31 downto 0 );
 dina : out STD_LOGIC_VECTOR ( 31 downto 0 );
 douta : in STD_LOGIC_VECTOR ( 31 downto 0 );
 
 clka_1 : out STD_LOGIC;
 rsta_1  : out STD_LOGIC;
 ena_1  : out STD_LOGIC;
 wea_1  : out STD_LOGIC_VECTOR ( 3 downto 0 );
 addra_1  : out STD_LOGIC_VECTOR ( 31 downto 0 );
 dina_1  : out STD_LOGIC_VECTOR ( 31 downto 0 );
 douta_1  : in STD_LOGIC_VECTOR ( 31 downto 0 );
 
 Ram_ID       : out std_logic_vector(31 downto 0);
 bramAvailable : out std_logic
 
  );
end BRam_Controller;

architecture Behavioral of BRam_Controller is
signal bramNo : std_logic :='0';
signal tvalid_reg : std_logic :='0';
signal switching_bram : std_logic:='0';
signal Ram_ID_reg       : std_logic_vector(31 downto 0):=(others=>'0');

signal addr_reg, addr_reg1 : STD_LOGIC_VECTOR ( 31 downto 0 ):=(others=>'0');
begin
------check rising_edge -----
process(aclk)
begin
if rising_edge(aclk) then
tvalid_reg<=tvalid;
end if ;
end process;
switching_bram<=tvalid_reg and not tvalid;

----------------------bram switching
process(aclk)
begin
if rising_edge(tvalid) then
bramNo<=not bramNo;
Ram_ID_reg<=Ram_ID_reg+1;
end if ;
end process;
----------------------------------
clka<=aclk;
clka_1<=aclk;
rsta <='0';
rsta_1 <='0';
----------------------bram writing 
process(aclk)
begin
if rising_edge(aclk) then
    if bramNo='0' and tvalid='1'then
    -----bram 1 enabled -----
        ena <='1';
        wea <=(others=>'1');
        addr_reg <= addr_reg + "100";
        dina <=tdata;
       -----bram 2 disabled ----- 
        ena_1 <='0';
        wea_1 <=(others=>'0');
        addr_reg1 <= (others=>'0');
        dina_1 <=(others=>'0');
           
           
    elsif bramNo='1' and tvalid='1' then
    -----bram 1 disabled -----
        ena <='0';
        wea <=(others=>'0');
        addr_reg <= (others=>'0');
        dina <=(others=>'0');
     -----bram 2 enabled -----   
        ena_1 <='1';
        wea_1 <=(others=>'1');
        addr_reg1 <= addr_reg1 + "100";
        dina_1 <=tdata;
     else 
     -----bram 1 disabled -----
         ena <='0';
         wea <=(others=>'0');
         addr_reg <= (others=>'0');
         dina <=(others=>'0');
         ------------
         ena_1 <='0';
         wea_1 <=(others=>'0');
        addr_reg1 <= (others=>'0');
        dina_1 <=(others=>'0');
        
    end if ;
end if ;     
    
end process;
---------------------------------
 bramAvailable<=not  bramNo;  
    
   Ram_ID<= Ram_ID_reg;
   addra <= addr_reg; 
   addra_1 <= addr_reg1; 
    
    end Behavioral;
