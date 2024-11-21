// Build with: g++ asm.cpp -O2 -oasm.exe -s -static
// On macOS:   g++ asm.cpp -O2 -oasm -std=c++11

// LICENSING INFORMATION
// This file is free software: you can redistribute it and/or modify it under the terms of the
// GNU General Public License as published by the Free Software Foundation, either
// version 3 of the License, or (at your option) any later version.
// This file is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY, without even the
// implied warranty of MERCHANMBBILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
// License for more details. You should have received a copy of the GNU General Public License along
// with this program. If not, see https://www.gnu.org/licenses/.

#include <vector>
#include <string>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <cstring>
#include <sstream>
#include <vector>
#include <algorithm>

// mnemonic tokens
const std::vector<std::string> MNEMONICS		// Index = OpCode
{
	"NOP","OUT","INT","INK","WIN","SEC","CLC","LL0","LL1","LL2","LL3","LL4","LL5","LL6","LL7","RL0",
	"RL1","RL2","RL3","RL4","RL5","RL6","RL7","RR1","LR0","LR1","LR2","LR3","LR4","LR5","LR6","LR7",
	"LLZ","LLB","LLV","LLW","LLQ","LLL","LRZ","LRB","RLZ","RLB","RLV","RLW","RLQ","RLL","RRZ","RRB",
	"NOT","NOZ","NOB","NOV","NOW","NOQ","NOL","NEG","NEZ","NEB","NEV","NEW","NEQ","NEL","ANI","ANZ",
	"ANB","ANT","ANR","ZAN","BAN","ORI","ORZ","ORB","ORT","ORR","ZOR","BOR","XRI","XRZ","XRB","XRT",
	"XRR","ZXR","BXR","FNE","FEQ","FCC","FCS","FPL","FMI","FGT","FLE","FPA","BNE","BEQ","BCC","BCS",
	"BPL","BMI","BGT","BLE","JPA","JPR","JAR","JPS","JAS","RTS","PHS","PLS","LDS","STS","RDB","RDR",
	"RAP","RZP","WDB","WDR","LDI","LDZ","LDB","LDT","LDR","LAP","LAB","LZP","LZB","STZ","STB","STT",
	"STR","SZP","MIZ","MIB","MIT","MIR","MIV","MIW","MZZ","MZB","MBZ","MBB","MVV","MWV","CLZ","CLB",
	"CLV","CLW","CLQ","CLL","INC","INZ","INB","INV","INW","INQ","INL","DEC","DEZ","DEB","DEV","DEW",
	"DEQ","DEL","ADI","ADZ","ADB","ADT","ADR","ZAD","BAD","TAD","RAD","ADV","ADW","ADQ","ADL","AIZ",
	"AIB","AIT","AIR","AIV","AIW","AIQ","AIL","AZZ","AZB","AZV","AZW","AZQ","AZL","ABZ","ABB","ABV",
	"ABW","ABQ","AVV","SUI","SUZ","SUB","SUT","SUR","ZSU","BSU","TSU","RSU","SUV","SUW","SUQ","LSU",
	"SIZ","SIB","SIT","SIR","SIV","SIW","SIQ","SIL","SZZ","SZB","SZV","SZW","SZQ","SZL","SBZ","SBB",
	"SBV","SBW","SBQ","SVV","CPI","CPZ","CPB","CPT","CPR","CIZ","CIB","CIT","CIR","CZZ","CZB","CBZ",
	"CBB","ACI","ACZ","ACB","ZAC","BAC","ACV","ACW","SCI","SCZ","SCB","ZSC","BSC","SCV","SCW","???"
};

// argument info: bits0-3: argtype1, bits 4-7: argtype2
// types: 0=none, 1=expect byte, 2=zero page, 3=expect word, 4=fast jump
const std::vector<int> ARGS // Index = OpCode
{
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
  0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,
  0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,
  0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,
  0x03,0x02,0x03,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x03,0x03,0x03,0x03,
  0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x00,0x00,0x00,0x01,0x01,0x13,0x03,
  0x03,0x32,0x13,0x03,0x01,0x02,0x03,0x02,0x03,0x01,0x03,0x12,0x32,0x02,0x03,0x02,
  0x03,0x12,0x21,0x31,0x21,0x31,0x23,0x33,0x22,0x32,0x23,0x33,0x22,0x23,0x02,0x03,
  0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,0x02,0x03,0x00,0x02,0x03,0x02,0x03,
  0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x21,
  0x31,0x21,0x31,0x21,0x31,0x21,0x31,0x22,0x32,0x22,0x32,0x22,0x32,0x23,0x33,0x23,
  0x33,0x23,0x22,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,0x02,0x03,
  0x21,0x31,0x21,0x31,0x21,0x31,0x21,0x31,0x22,0x32,0x22,0x32,0x22,0x32,0x23,0x33,
  0x23,0x33,0x23,0x22,0x01,0x02,0x03,0x02,0x03,0x21,0x31,0x21,0x31,0x22,0x32,0x23,
  0x33,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x01,0x02,0x03,0x02,0x03,0x02,0x03,0x00
};

class HexPrinter // handling output in 'Intel HEX' format
{
  public:
    HexPrinter(std::stringstream& out) : mOut(out) {}
    ~HexPrinter() { if (isactive) { if (used > 0) emitBuffer(); mOut << ":00000001FF\n"; } } // write end of hex file
    void SetAddress(int laddr) { if (used > 0) emitBuffer(); linaddr = laddr; } // begin new line at new address
    int GetAddress() { return linaddr + used; } // returns the current emission address
    void Emit(uint8_t b) { isactive = true; buffer[used++] = b; if (used == 16) emitBuffer(); } // emit a byte
  protected:
    void emitBuffer() // emits current buffer as a line (only call if buffer is non-empty!)
    {
      mOut << ":" << std::hex << std::uppercase << std::setfill('0');
      uint8_t pch = (linaddr & 0xff00)>>8;
      uint8_t pcl = linaddr & 0x00ff;
      mOut << std::setw(2) << used << std::setw(2) << int(pch) << std::setw(2) << int(pcl) << "00";
      uint8_t checksum = used + pch + pcl;
      for(int i=0; i<used; i++) { mOut << std::setw(2) << int(buffer[i]); checksum += buffer[i]; }
      mOut << std::setw(2) << int((~checksum + 1) & 0xff) << "\n";
      linaddr += used; used = 0;
    }
    bool isactive = false;
    uint8_t buffer[16]{}; // emission line buffer
    int used{ 0 }; // number of emitted bytes pending in buffer
    int linaddr{ 0 }; // start address of the current data in buffer
    std::stringstream& mOut; // emission into this string stream
};

int opCode(const std::string& s, int p, int len) // returns the op code at the specified position and length
{
  if (len < 3 || len > 4) return -1; // can't be an op code

  char mne[4]; mne[3] = 0;
  if (len == 4) // mnemonic has a dot AB.C -> CAB
  {
    if (s[p+2] == '.') { mne[0] = s[p+3]; mne[1] = s[p+0]; mne[2] = s[p+1]; } else return -1;
  }
  else { mne[0] = s[p+0]; mne[1] = s[p+1]; mne[2] = s[p+2]; }
  
  for (int i=0; i<3; i++) if (mne[i] & 0b01000000) mne[i] = mne[i] & 0b11011111;

  for(int i=0; i<MNEMONICS.size(); i++) if (strcmp(mne, MNEMONICS[i].c_str()) == 0) return i;

  return -1;
}

int ln(const std::string& s, int p) // calculates the line number of the element pos in the source
{
  int num = 1;
  for (int i=0; i<=p; i++) if (s[i] == '\n') num++;
  return num;
}

int findelem(const std::string& s, int& ep) // moves ep to an element and returns its length, 0: valid EOF, -1: error
{
  while (true)
  {
    if (s[ep] == 0) return 0; // handle EOF
    else if (s[ep] <= 32 || s[ep] == ',') ep++; // handle whitespaces
    else // it must be a real character
    {
      if (s[ep] == ';') // handle ; comments
      {
        while (true)
        {
          ep++;
          if (s[ep] == 0) return 0; // EOF at the end of a comment reached
          if (s[ep] == '\n') { ep++; break; } // consume LF and close comment
        }
      }
      else // element start, now calc its length
      {
        int n = ep; // from now on, parse with a separate pointer
        while(true)
        {
          if (s[n] == '\"' || s[n] == '\'')
          {
            char quote = s[n++]; // remember quotation style
            while (s[n] != quote) if (s[n++] < 32) return -1; // EOF \n \r \t = error
            n++; // consume end quotation
          }
          else // standard element or whitespace end?
          {
            if (s[n] <= 32 || s[n] == ',' || s[n] == ';') return n - ep; // element end reached
            n++; // consume element char
          }
        }
      }
    }
  }
}

// pass 1 (isparse = false): only sets descriptive flags, pass 2: (isparse = true): also computes expression value
// prior to calling, check for: label-def, long strings, pre-proc
bool parseExpr(const std::string& src, const int ep, const int elen, std::stringstream& errors,
               const std::vector<std::string>& labels, const std::vector<int>& labelpc,
               bool& isop, bool& isword, bool& islsb, bool& ismsb, const bool isparse,
               int& lsb, int& msb, HexPrinter& hex)
{
  isop = isword = islsb = ismsb = false; // all flags off

  if ((lsb = opCode(src, ep, elen)) != -1) { isop = true; return true; }

  int expr = 0, x = ep; // init result

  if (src[x] == '<' || src[x] == '>') // exptract a leading MSB/LSB operator
  {
    if (src[x++] == '<') islsb = true; else ismsb = true;
  }

  do
  {
    int term = 0, sign = 1;

    if (src[x] == '+') { sign = 1; x++; } // take leading sign, reset term
    else if (src[x] == '-') { sign = -1; x++; }

    if (src[x] == '\'') // single characters '.'
    {
      if (elen >= 3 && src[x+2] == '\'') { term = src[x+1]; x += 3; }
      else { errors << "ERROR in line " << ln(src, ep) << ": Invalid expression.\n"; return false; }
    }
    else if (src[x] == '\"') // single characters "."
    {
      if (elen >= 3 && src[x+2] == '\"') { term = src[x+1]; x += 3; }
      else { errors << "ERROR in line " << ln(src, ep) << ": Invalid expression.\n"; return false; }
    }
    else if (src[x] == '0' && src[x+1] == 'x') // hex number
    {
      size_t k = src.find_first_not_of("0123456789abcdefABCDEF", x+2);
      if (k == std::string::npos) k = ep + elen;
      if (k == x+2) { errors << "ERROR in line " << ln(src, ep) << ": Invalid HEX value.\n"; return false; }
      else
      {
        if (isparse) term = std::stoi(src.substr(x+2, k-(x+2)), nullptr, 16);
        if (k > x+4) isword = true;
      }
      x = k;
    }
    else if (src[x] == '*') { term = hex.GetAddress(); isword = true; x++; } // * = emission pointer
    else if (src[x] >= '0' && src[x] <= '9') // decimal number
    {
      while (src[x] >= '0' && src[x] <= '9') { term *= 10; term += src[x++] - '0'; }
      if (sign*term > 255 || sign*term < -128) isword = true; // use chose word deliberately
    }
    else // must be a label ref or embedded mnemonic
    {
      size_t k = src.find_first_of(" +-\n\r\t,;\0", x); // find end of label ref (k is well-defined <= ep + elen)
      if (k == x) { errors << "ERROR in line " << ln(src, ep) << ": Empty expression.\n"; return false; }
      if ((term = opCode(src, x, k-x)) == -1) // op code as part of an expression? ... or label ref?
      {
        isword = true;
        if (isparse) // only possible during pass 2
        {
          std::string ref = src.substr(x, k-x); // cut out this reference
          bool isknown = false; // is it a known label?
          for(int i=0; i<labels.size(); i++) // find value of label
            if (ref == labels[i]) { term = labelpc[i]; isknown = true; break; }
          if (!isknown) { errors << "ERROR in line " << ln(src, ep) << ": Unknown reference \'" << ref << "\'.\n"; return false; }
        }
      }
      x = k; // consume this element part
    }
    expr += sign * term; // add this term to the expression
  } while (src[x] == '+' || src[x] == '-');

  if (x != ep + elen) { errors << "ERROR in line " << ln(src, ep) << ": Invalid expression.\n"; return false; }

  lsb = expr & 0xff; msb = (expr >> 8) & 0xff; // store resulting LSB/MSB
  return true; // success
}

void Assembler(const std::string& src, std::stringstream& hexout, std::stringstream& errors, bool dosym, std::string symtag)
{
  std::vector<std::string> labels; // Liste aller Label-Definitionen mit ":"
  std::vector<int> labelpc; // Adresse aller Label-Definitionen
  HexPrinter hex(hexout); // contains an "emission counter", use HEX.GetAddress()
  bool isemit = true; // default true
  bool isop, isword, islsb, ismsb; // expression result flags
  int lsb, msb; // expression result
  int args = 0; // "expect" arguments nibble pipeline
  int elen = 0; // length of current element at ep
  int pc = 0; // program counter keeping track of target location
  int ep = 0; // elememt string index

// ******************
// ***** PASS 1 *****
// ******************
  while ((elen = findelem(src, ep)) > 0) // any element to process?
  {
    // always parse for...
    if (src[ep+elen-1] == ':') // label definition
    {
      std::string def = src.substr(ep, elen-1);
      for(int i=0; i<labels.size(); i++) // search existing label database
        if (def == labels[i]) { errors << "ERROR in line " << ln(src, ep) << ": Definition already exists.\n"; return; }
      labels.emplace_back(src.substr(ep, elen-1)); labelpc.emplace_back(pc); // accept as new definition
    }
    else if (src[ep] == '#') // preprocessor command (ignore any #... but #org in pass 1)
    {
      if (elen == 4 && src.substr(ep+1,3) == "org")
      {
        bool isOrg = false; ep += elen; elen = findelem(src, ep); // consume '#org' element and look for next element '0x....'
        if (elen > 2 && elen <=6 && src[ep] == '0' && src[ep+1] == 'x') // any hex word 0x.
        {
          size_t k = src.find_first_not_of("0123456789abcdefABCDEF", ep+2);
          if (k == std::string::npos) k = ep + elen;
          if (k == ep + elen) { pc = std::stoi(src.substr(ep+2, k - (ep+2)), nullptr, 16); isOrg = true; }
        }
        if (!isOrg) { errors << "ERROR in line " << ln(src, ep) << ": Expecting a 16-bit HEX address.\n"; return; }
      }
      else if (elen == 5 && src.substr(ep+1, 4) == "page")
      {
        int delta = (-(pc & 0xff)) & 0xff;
        pc += delta;
      }
    }
    else // PARSE MODE-SPECIFICALLY
    {
      switch (args & 0x0f) // handle different expectation modes
      {
        case 0: // no expectations
        {
          if (src[ep] == '\'' && src[ep+elen-1] == '\'') pc += elen-2; // pure 'string'
          else if (src[ep] == '\"' && src[ep+elen-1] == '\"') pc += elen-2; // pure "string"
          else
          {
            if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, false, lsb, msb, hex)) return;
            if (isop) { args = ARGS[lsb]; pc++; } // instruction-specific arguments
            else if (isword && !islsb && !ismsb) pc+=2;
            else pc++;
          }
          break;
        }
        case 1: // expect a byte argument
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, false, lsb, msb, hex)) return;
          if (!isop && (!isword || islsb || ismsb)) pc++;
          else { errors << "ERROR in line " << ln(src, ep) << ": Expecting a byte argument.\n"; return; }
          args >>= 4;
          break;
        }
        case 2: // expect zero-page argument
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, false, lsb, msb, hex)) return;
          if (!isop && !ismsb) pc++;
          else { errors << "ERROR in line " << ln(src, ep) << ": Expecting a zero-page argument.\n"; return; }
          args >>= 4;
          break;
        }
        case 3: // expect a word argument (may be LSB followed by MSB, too)
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, false, lsb, msb, hex)) return;
          if (isop) { errors << "ERROR in line " << ln(src, ep) << ": Expecting a word argument.\n"; return; }
          else if (isword && !islsb && !ismsb) { pc+=2; args >>= 4; }
          else { pc++; args = (args & 0xf0) | 0x01; } // change expectation to byte (trailing MSB)
          break;
        }
        case 4: // expect a fast jump argument
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, false, lsb, msb, hex)) return;
          if (!isop && !ismsb) pc++; else { errors << "ERROR in line " << ln(src, ep) << ": Invalid fast jump.\n"; return; }
          args >>= 4;
          break;
        }
      }
    }
    ep += elen; // consume processed element
  }
  if (elen == -1) { errors << "ERROR in line " << ln(src, ep) << ": Invalid element.\n"; return; }

  // ***********************************************************
  // ***** output symbolic constants [starting with 'tag'] *****
  // ***********************************************************
  if (dosym)
  {
    for(int k=0; k<labels.size(); k++) // Prüfe: Ist das Element ein label?
    {
      int adr = labelpc[k];
      if (symtag == labels[k].substr(0, symtag.length()))
      {
        hexout << "#org 0x" << std::hex << std::setfill('0') << std::setw(2) << int((adr & 0xff00) >> 8) << std::setw(2) << int(adr&0x00ff) << " " << labels[k] << ":\n";
      }
    }
    return;
  }

  // ******************
  // ***** PASS 2 *****
  // ******************
  args = ep = pc = 0; // reset state, back to start of source, use pc for fast-jump check

  while ((elen = findelem(src, ep)) > 0) // any element to process?
  {
    // always parse for...
    if (src[ep+elen-1] == ':'); // ignore label definitions in pass 2
    else if (src[ep] == '#') // handle all preprocessor commands
    {
      if (elen == 5)
      {
        if (src.substr(ep+1, 4) == "mute") isemit = false;
        else if (src.substr(ep+1, 4) == "emit") isemit = true;
        else if (src.substr(ep+1, 4) == "page")
        {
          int delta = (-(pc & 0xff)) & 0xff;
          pc += delta;
          if (isemit) hex.SetAddress(hex.GetAddress() + delta);
        }
      }
      else if (elen == 4 && src.substr(ep+1, 3) == "org")
      {
        ep += elen; elen = findelem(src, ep); // this #org 0x. is already known to be parsable from pass 1
        size_t k = src.find_first_not_of("0123456789abcdefABCDEF", ep+2);
        if (k == std::string::npos) k = ep + elen;
        pc = std::stoi(src.substr(ep+2, k - (ep+2)), nullptr, 16); // always set pc...
        if (isemit) hex.SetAddress(pc); // ... but set mc only while emitting
      }
      else { errors << "ERROR in line " << ln(src, ep) << ": Unknown pre-proc command.\n"; return; }
    }
    else // parse mode-specifically
    {
      switch (args & 0x0f) // handle different expectation modes
      {
        case 0: // expect anything (including strings, opcodes, constants)
        {
          if ((src[ep] == '\'' || src[ep] == '\"') && elen > 3) // string, but not a single char, matching quotes are tested earlier
            for (int i=ep+1; i<ep+elen-1; i++) { pc++; if (isemit) hex.Emit(src[i]); }
          else // expression (may include single chars, mnemonics, ...)
          {
            if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, true, lsb, msb, hex)) return;
            if (isop) { args = ARGS[lsb]; pc++; if (isemit) hex.Emit(lsb); } // pure mnemonic allowed here
            else if (islsb) { pc++; if (isemit) hex.Emit(lsb); }
            else if (ismsb) { pc++; if (isemit) hex.Emit(msb); }
            else if (isword) { pc+=2; if (isemit) { hex.Emit(lsb); hex.Emit(msb); } } // ... but not islsb or ismsb
            else
            {
              if (msb == 0x00 || (msb == 0xff && (lsb & 0x80) == 0x80)) { pc++; if (isemit) hex.Emit(lsb); }
              else { errors << "ERROR in line " << ln(src, ep) << ", lsb=" << lsb << ", msb=" << msb << ": Expression size unclear.\n"; return; }
            }
          }
          break;
        }
        case 1: // expect byte argument
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, true, lsb, msb, hex)) return;
          if (islsb) { pc++; if (isemit) hex.Emit(lsb); }
          else if (ismsb) { pc++; if (isemit) hex.Emit(msb); }
          else if (isop || isword) { errors << "ERROR in line " << ln(src, ep) << ": Expecting byte expression.\n"; return; }
          else
          {
            if (msb == 0x00 || (msb == 0xff && (lsb & 0x80) == 0x80)) { pc++; if (isemit) hex.Emit(lsb); }
            else { errors << "ERROR in line " << ln(src, ep) << ": Expecting byte expression.\n"; return; }
          }
          args >>= 4;
          break;
        }
        case 2: // zero page argument
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, true, lsb, msb, hex)) return;
          if (isop || ismsb) { errors << "ERROR in line " << ln(src, ep) << ": Expecting a zero-page argument.\n"; return; }
          else if (islsb || msb == 0x00) { pc++; if (isemit) hex.Emit(lsb); }
          else { errors << "ERROR in line " << ln(src, ep) << ": Expecting a zero-page argument.\n"; return; }
          args >>= 4;
          break;
        }
        case 3: // expect word
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, true, lsb, msb, hex)) return;
          if (isop) { errors << "ERROR in line " << ln(src, ep) << ": Expecting a word argument.\n"; return; } // redundant
          else if (islsb) { pc++; args = (args & 0xf0) | 0x01; if (isemit) hex.Emit(lsb); }
          else if (ismsb) { pc++; args = (args & 0xf0) | 0x01; if (isemit) hex.Emit(msb); }
          else if (isword) { pc+=2; args >>= 4; if (isemit) { hex.Emit(lsb); hex.Emit(msb); } }
          else if (msb == 0x00 || (msb == 0xff && (lsb & 0x80) == 0x80)) { pc++; args = (args & 0xf0) | 0x01; if (isemit) hex.Emit(lsb); }
          else { errors << "ERROR in line " << ln(src, ep) << ": Unclear word argument.\n"; return; } // { pc+=2; args >>= 4; if (isemit) { hex.Emit(lsb); hex.Emit(msb); } }
          break;
        }
        case 4: // expect fast jump
        {
          if (!parseExpr(src, ep, elen, errors, labels, labelpc, isop, isword, islsb, ismsb, true, lsb, msb, hex)) return;
          if (!isop && !ismsb && (islsb || msb == ((pc >> 8) & 0xff))) { pc++; if (isemit) hex.Emit(lsb); }
          else { errors << "ERROR in line " << ln(src, ep) << ": Invalid fast jump.\n"; return; }
          args >>= 4;
          break;
        }
      }
    }
    ep += elen; // hop over the processed element
  }

  if (elen == -1) { errors << "ERROR in line " << ln(src, ep) << ": Invalid element.\n"; return; }
  if (args != 0) { errors << "ERROR in line " << ln(src, ep) << ": Missing argument.\n"; return; }
}

int main(int argc, char *argv[])
{
  std::cout << "Minimal Smart Assembler by C. Herting (slu4) 2024\n\n"; // output help screen

  bool dosym = false; // by default don't output a symbol table
  std::string symtag = ""; // by default don't use any symbol tag
  int filenamepos = 0; // extract possible -s parameter and filename
  for (int i=1; i<argc; i++) // index zero contains "asm" itself
  {
    if (argv[i][0] == '-' && argv[i][1] == 's')  { dosym = true; symtag = std::string(&argv[i][2]); }
    else filenamepos = i; // nope, plain filename => remember it's index inside argv[]
  }

  if (filenamepos > 0) // does a valid argument position of a filename exist?
  {
    std::ifstream file(argv[filenamepos]);
    if (file.is_open())
    {
      std::string source;

/* // testsuite "test.asm", use with raw HexPrinter
      while(std::getline(file, source, '|'))
      {
        std::string result; std::getline(file, result, '\n');
        std::stringstream hexout, errors;
        Assembler(source, hexout, errors, dosym, symtag);
        
        if (errors.str().size() > 0)
        {
          if (result == "") std::cout << "+:";
          else std::cout << "-:" << hexout.str() << "/" << result << ":";
        }
        else if (hexout.str() == result) std::cout << "+:"; else std::cout << "-:" << hexout.str() << "/" << result << ":";
        std::cout << source << std::endl;
      }
*/

      std::stringstream hexout, errors;
      std::getline(file, source, '\0');
      file.close();
      Assembler(source, hexout, errors, dosym, symtag);
      if (errors.str().size() == 0) std::cout << hexout.str(); else std::cout << errors.str();

    }
    else std::cout << ("ERROR: Can't open \"" + std::string(argv[filenamepos]) + "\".\n");
  }
  else
  {
    std::cout << "Usage: asm <sourcefile> [-s[<tag>]]\n\n";
    std::cout << "assembles a <sourcefile> to machine code and outputs\n";
    std::cout << "the result in 'Intel HEX' format to the console.\n\n";
    std::cout << "  -s[<tag>]  appends a list of symbolic constants\n";
    std::cout << "             [starting with <tag>] and their values.\n";
  }
  return 0;
}
